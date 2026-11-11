// Ray-traced light shafts (rt.rs): for each pixel, steps through the air
// from the camera to what it sees, each asking the scene whether the sun
// reaches that bit of air (past hills, trees, leaves, riders), so the lit
// air glows and the shaded air does not: beams through the trees and past
// whatever stands in the sun, strongest looking toward it. In place of the
// screen-space shafts (post.wgsl `shafts`), which needed the sun on
// screen. Out as the shadows' raw texture is, for the same blend over time
// and blur: x how much sunlight the air sends toward the eye, y how far
// the pixel's surface is, z a stand-in shade distance that sets the blur's
// width, w 1 on a moving model.

enable wgpu_ray_query;

struct Params {
    inverse_view_proj: mat4x4<f32>,
    camera: vec4<f32>,
    to_sun: vec4<f32>,
    // The scene's size in pixels, the frame's number, and a pixel's width
    // a ft away.
    size: vec4<f32>,
    previous: mat4x4<f32>,
    history: vec4<f32>,
};

@group(0) @binding(0) var<uniform> params: Params;
@group(0) @binding(1) var depth: texture_depth_2d;
@group(0) @binding(2) var scene: acceleration_structure;
@group(0) @binding(3) var<storage, read> cutouts: array<vec4<f32>>;
@group(0) @binding(4) var masks: texture_2d_array<f32>;
@group(0) @binding(5) var mask_sampler: sampler;
// The shadows' raw texture, for whether each pixel is on a moving model.
@group(0) @binding(6) var shadows: texture_2d<f32>;
@group(0) @binding(7) var out: texture_storage_2d<rgba16float, write>;

// How far the steps go, ft, and how many there are.
const REACH: f32 = 600.0;
const STEPS: u32 = 3u;
// The blur's width, pixels (rt_blur.wgsl's sun radius, to set it by).
const BLUR: f32 = 5.0;
const SUN_RADIUS: f32 = 0.0047;
// How far along a ray toward the sun leaves stop it, ft.
const CUTOUT_REACH: f32 = 300.0;

fn noise(p: vec2<f32>) -> f32 {
    return fract(52.9829189 * fract(dot(p, vec2<f32>(0.06711056, 0.00583715))));
}

// Whether the sun reaches `p`: past what is solid, and the leaves and
// fences where their masks are solid (blurred, as the beams are soft).
fn sunlit(p: vec3<f32>) -> f32 {
    var rq: ray_query;
    rayQueryInitialize(&rq, scene, RayDesc(RAY_FLAG_TERMINATE_ON_FIRST_HIT, 0xffu, 0.0, 6000.0, p, params.to_sun.xyz));
    var through = 1.0;
    while (rayQueryProceed(&rq)) {
        let c = rayQueryGetCandidateIntersection(&rq);
        if (c.kind != RAY_QUERY_INTERSECTION_TRIANGLE || c.t > CUTOUT_REACH) {
            continue;
        }
        let r = (c.instance_custom_data + c.primitive_index) * 2u;
        let a = cutouts[r];
        let b = cutouts[r + 1u];
        let w = c.barycentrics;
        let uv = a.xy * (1.0 - w.x - w.y) + a.zw * w.x + b.xy * w.y;
        through *= 1.0 - textureSampleLevel(masks, mask_sampler, uv, i32(b.z), 3.0).r;
        if (through < 0.1) {
            rayQueryConfirmIntersection(&rq);
        }
    }
    if (rayQueryGetCommittedIntersection(&rq).kind != RAY_QUERY_INTERSECTION_NONE) {
        return 0.0;
    }
    return through;
}

// How strongly air scatters light toward the eye at `cos` from the sun
// (Henyey-Greenstein): mostly forward, so the beams show looking into the
// light, and a little always.
fn phase(cos: f32) -> f32 {
    let g = 0.6;
    let forward = (1.0 - g * g) / pow(1.0 + g * g - 2.0 * g * cos, 1.5);
    return 0.25 + forward;
}

@compute @workgroup_size(8, 8)
fn scatter(@builtin(global_invocation_id) id: vec3<u32>) {
    let p = vec2<i32>(id.xy);
    if (f32(p.x) >= params.size.x || f32(p.y) >= params.size.y) {
        return;
    }
    let own = textureLoad(shadows, p, 0);
    let d = textureLoad(depth, p, 0);
    let ndc = vec2<f32>((f32(p.x) + 0.5) / params.size.x * 2.0 - 1.0, 1.0 - (f32(p.y) + 0.5) / params.size.y * 2.0);
    let h = params.inverse_view_proj * vec4<f32>(ndc, d, 1.0);
    let toward = h.xyz / h.w - params.camera.xyz;
    let dir = normalize(toward);
    var dist = select(length(toward), 1e9, d >= 1.0);
    let length_ = min(dist, REACH);
    let jitter = noise(vec2<f32>(id.xy) + params.size.z * 5.588238);
    var lit = 0.0;
    for (var i = 0u; i < STEPS; i++) {
        // Evenly along the view, each standing for as much air, so the
        // shade round the eye takes only its own share.
        let k = (f32(i) + jitter) / f32(STEPS);
        lit += sunlit(params.camera.xyz + dir * length_ * k);
    }
    // The sunlit share of the air looked through, by how far, and as it
    // scatters toward the eye; sky as far off as the steps reach.
    let air = lit / f32(STEPS) * length_ / REACH * phase(dot(dir, params.to_sun.xyz));
    // The sky too is blended over time and blurred (the shadows' passes
    // leave out what is past 50000 ft): it is where the beams show most.
    // The sky as far as the far plane, where the blend over time finds it
    // too.
    let shown = length(toward);
    let blur = BLUR * min(shown, REACH) * params.size.w / SUN_RADIUS;
    textureStore(out, p, vec4<f32>(air, shown, blur, own.w));
}
