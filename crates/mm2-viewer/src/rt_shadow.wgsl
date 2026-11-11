// The ray-traced sun shadows (rt.rs): for each pixel of the scene, from
// where the depth pass put the nearest surface, rays toward points on the
// sun's disc. Out: x how much sun reaches it, y how far it is from the
// camera, z how far along the rays what shades it is (0 for nothing).

enable wgpu_ray_query;

struct Params {
    // From the screen (x, y -1 to 1, depth) to the drawing.
    inverse_view_proj: mat4x4<f32>,
    camera: vec4<f32>,
    // The way to the sun, and in w which instances cast (rt.rs).
    to_sun: vec4<f32>,
    // The scene's size in pixels, the frame's number, and a pixel's width
    // a ft away.
    size: vec4<f32>,
    // The frame before's view and projection, and x whether there is
    // one, yzw where its camera was (rt_temporal.wgsl).
    previous: mat4x4<f32>,
    history: vec4<f32>,
};

@group(0) @binding(0) var<uniform> params: Params;
@group(0) @binding(1) var depth: texture_depth_2d;
@group(0) @binding(2) var scene: acceleration_structure;
@group(0) @binding(3) var<storage, read> cutouts: array<vec4<f32>>;
@group(0) @binding(4) var masks: texture_2d_array<f32>;
@group(0) @binding(5) var mask_sampler: sampler;
@group(0) @binding(6) var traced: texture_storage_2d<rgba16float, write>;
// What the rays meet (rt.rs Reflections): the instances' parts and each
// triangle's object vertices, the objects' vertices (objects.rs Vertex,
// ten words) and the nodes that move them.
@group(0) @binding(7) var<storage, read> hits: array<vec4<u32>>;
@group(0) @binding(8) var<storage, read> vertices: array<u32>;
@group(0) @binding(9) var<storage, read> nodes: array<mat4x4<f32>>;
// The moving models' posed vertices the frame before (rt.rs Moving), their
// triangles (solid, cut out), and where each pixel on one was on screen
// then: its move in pixels, how far from that frame's camera, and 1.
@group(0) @binding(10) var<storage, read> before: array<f32>;
@group(0) @binding(11) var<storage, read> moving_solid: array<u32>;
@group(0) @binding(12) var<storage, read> moving_cut: array<u32>;
@group(0) @binding(13) var motion: texture_storage_2d<rgba16float, write>;

// How wide the sun looks, radians: the real one's quarter degree, so
// shadows soften the farther they fall and a gantry's lattice still shows.
const SUN_RADIUS: f32 = 0.0047;
// How far a ray looks for something in the way, ft: past the haze.
const RAY_REACH: f32 = 6000.0;
// How far along a ray cut-outs (leaves, fences) stop it, ft, and how far
// from the camera they cast at all: past that they would cast only a
// faint blur, and a forest's leaves are many to look through.
const CUTOUT_REACH: f32 = 300.0;
const CUTOUT_SHOWN: f32 = 250.0;
// The terrain's instance mask (rt.rs TERRAIN), and how far above a
// surface its rays toward the hills start, ft.
const TERRAIN: u32 = 1u;
const MOVING: u32 = 4u;
const TERRAIN_LIFT: f32 = 0.5;

struct Ray {
    // How much light it brings from the sky, 0 to 1, and how far along it
    // what shades it is (0 for nothing).
    light: f32,
    shade: f32,
};

// A ray from `origin` along `dir`: none of the light if something solid
// is in the way; through a cut-out what its mask lets by, the mask as
// blurred as the ray's cone is wide where it meets it (`spread` ft at the
// start, widening as the sun's disc does), so foliage far up casts a
// soft dapple.
fn ray_from(origin: vec3<f32>, dir: vec3<f32>, mask: u32, spread: f32, flags: u32, start: f32, through_in: f32) -> Leg {
    // The nearest it meets, not the first found: whether that is a face
    // from behind (see `ray`) must not hang on how the moving models'
    // structure happened to be built this frame, or their shadows flicker.
    var rq: ray_query;
    rayQueryInitialize(&rq, scene, RayDesc(flags, mask, start, RAY_REACH, origin, dir));
    var through = through_in;
    var first = 0.0;
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
        // About as wide as the sun's disc is there, less a little: the
        // two rays and the blur after soften it the rest of the way.
        let wide = spread * 0.5 + c.t * SUN_RADIUS;
        let lod = log2(max(wide * b.w, 1.0));
        let solid = textureSampleLevel(masks, mask_sampler, uv, i32(b.z), lod).r;
        // Sharp where the mask is sharp, a fraction where it is blurred.
        let cover = select(smoothstep(0.0, 1.0, solid), step(0.5, solid), lod < 0.5);
        if (cover > 0.05 && (first == 0.0 || c.t < first)) {
            first = c.t;
        }
        through *= 1.0 - cover;
        if (through < 0.1) {
            rayQueryConfirmIntersection(&rq);
        }
    }
    var out: Leg;
    out.hit = rayQueryGetCommittedIntersection(&rq);
    out.through = through;
    out.first = first;
    return out;
}

// One stretch of a ray: what stopped it, if anything, how much light got
// through the cut-outs on the way, and how far along the first was.
struct Leg {
    hit: RayIntersection,
    through: f32,
    first: f32,
};

// Which way the object triangle a ray met faces outward, by its vertices'
// normals (turned with its part if it moves): the meshes' windings are
// not to be trusted, the normals the game lights them by are.
fn outward(h: RayIntersection) -> vec3<f32> {
    let head = hits[h.instance_index / 2u];
    let base = select(select(head.x, head.y, h.geometry_index == 1u), select(head.z, head.w, h.geometry_index == 1u), (h.instance_index & 1u) == 1u);
    let tri = hits[base + h.primitive_index];
    let w = vec3<f32>(1.0 - h.barycentrics.x - h.barycentrics.y, h.barycentrics.x, h.barycentrics.y);
    var n = vec3<f32>(0.0);
    for (var k = 0u; k < 3u; k++) {
        let i = tri[k] * 10u;
        n += vec3<f32>(bitcast<f32>(vertices[i + 3u]), bitcast<f32>(vertices[i + 4u]), bitcast<f32>(vertices[i + 5u])) * w[k];
    }
    if (h.instance_index == hits[1].w) {
        n = (nodes[vertices[tri.x * 10u + 9u] & 0x3fffffffu] * vec4<f32>(n, 0.0)).xyz;
    }
    return n;
}

// A ray from `origin` along `dir`. What it meets from behind (facing the
// way the ray goes) is the inside of the very surface it left: a low-poly
// curve whose flat faces stand proud of its smooth lighting where the sun
// grazes it, and would shade it in jagged steps. The ray goes on past
// that, a few times at most.
fn ray(origin: vec3<f32>, dir: vec3<f32>, mask: u32, spread: f32, flags: u32) -> Ray {
    var start = 0.0;
    var through = 1.0;
    var first = 0.0;
    var out = Ray(1.0, 0.0);
    for (var leg = 0u; leg < 4u; leg++) {
        let got = ray_from(origin, dir, mask, spread, flags, start, through);
        through = got.through;
        if (got.first > 0.0 && first == 0.0) {
            first = got.first;
        }
        if (got.hit.kind == RAY_QUERY_INTERSECTION_NONE) {
            out.light = through;
            out.shade = first;
            return out;
        }
        if (got.hit.instance_index != 0u && dot(outward(got.hit), dir) > 0.0) {
            start = got.hit.t + 0.01;
            continue;
        }
        out.light = 0.0;
        out.shade = got.hit.t;
        return out;
    }
    out.light = through;
    out.shade = first;
    return out;
}

// 1 if `world` (`dist` ft from the camera, `to_eye` toward it) is on a
// moving model, 0 if not: a ray from the camera to it, against the moving
// models alone, meets one there. Their frames before are not where the
// camera's own move says, so the blend over time leaves them out.
fn on_moving(world: vec3<f32>, to_eye: vec3<f32>, dist: f32, pixel: vec2<i32>) -> f32 {
    textureStore(motion, pixel, vec4<f32>(0.0));
    let mover = hits[1].w;
    if (mover == 0xffffffffu) {
        return 0.0;
    }
    var rq: ray_query;
    rayQueryInitialize(&rq, scene, RayDesc(RAY_FLAG_FORCE_OPAQUE, MOVING, max(dist - 1.0, 0.0), dist + 1.0, params.camera.xyz, -to_eye / max(dist, 1e-3)));
    rayQueryProceed(&rq);
    let hit = rayQueryGetCommittedIntersection(&rq);
    if (hit.kind == RAY_QUERY_INTERSECTION_NONE) {
        return 0.0;
    }
    // The same place on the triangle, where its vertices were a frame
    // ago, and where that was on screen.
    let w = vec3<f32>(1.0 - hit.barycentrics.x - hit.barycentrics.y, hit.barycentrics.x, hit.barycentrics.y);
    var was = vec3<f32>(0.0);
    for (var k = 0u; k < 3u; k++) {
        let at = hit.primitive_index * 3u + k;
        let i = select(moving_solid[at], moving_cut[at], hit.geometry_index == 1u);
        was += vec3<f32>(before[i * 3u], before[i * 3u + 1u], before[i * 3u + 2u]) * w[k];
    }
    let c = params.previous * vec4<f32>(was, 1.0);
    if (params.history.x > 0.5 && c.w > 0.0) {
        let uv = vec2<f32>(c.x / c.w * 0.5 + 0.5, 0.5 - c.y / c.w * 0.5);
        let then = uv * params.size.xy - (vec2<f32>(pixel) + 0.5);
        textureStore(motion, pixel, vec4<f32>(then, length(params.history.yzw - was), 1.0));
    }
    return 1.0;
}

// Interleaved gradient noise (Jimenez 2014): a different turn for each
// pixel that the blur after evens out.
fn noise(p: vec2<f32>) -> f32 {
    return fract(52.9829189 * fract(dot(p, vec2<f32>(0.06711056, 0.00583715))));
}

@compute @workgroup_size(8, 8)
fn trace(@builtin(global_invocation_id) id: vec3<u32>) {
    let size = vec2<u32>(params.size.xy);
    if (id.x >= size.x || id.y >= size.y) {
        return;
    }
    let d = textureLoad(depth, vec2<i32>(id.xy), 0);
    if (d >= 1.0) {
        textureStore(traced, vec2<i32>(id.xy), vec4<f32>(1.0, 60000.0, 0.0, 0.0));
        textureStore(motion, vec2<i32>(id.xy), vec4<f32>(0.0));
        return;
    }
    let ndc = vec2<f32>(
        (f32(id.x) + 0.5) / params.size.x * 2.0 - 1.0,
        1.0 - (f32(id.y) + 0.5) / params.size.y * 2.0,
    );
    let h = params.inverse_view_proj * vec4<f32>(ndc, d, 1.0);
    let world = h.xyz / h.w;
    let to_eye = params.camera.xyz - world;
    let dist = length(to_eye);
    let to_sun = params.to_sun.xyz;
    // Off the surface toward the sun and the camera, farther the farther
    // away: the depth's precision and the triangles' own flatness.
    let off = 0.04 + dist * 0.0006;
    let origin = world + to_sun * off + to_eye / max(dist, 1e-3) * off;
    let mask = u32(params.to_sun.w);
    let spread = dist * params.size.w;
    let flags = select(0u, RAY_FLAG_CULL_NO_OPAQUE, dist > CUTOUT_SHOWN);
    // Two points on the sun's disc at opposite sides, turned for each
    // pixel and frame; where they disagree (a shadow's edge), six more on
    // a spiral, so the soft edges are smooth and the rest costs two rays
    // (as OpenMM2's ray traced sun shadows do).
    let side = normalize(cross(to_sun, select(vec3<f32>(0.0, 1.0, 0.0), vec3<f32>(1.0, 0.0, 0.0), abs(to_sun.y) > 0.99)));
    let up = cross(side, to_sun);
    let turn = noise(vec2<f32>(id.xy) + params.size.z * 5.588238) * 6.2831853;
    var light = 0.0;
    var shade = 0.0;
    var shaded = 0.0;
    var rays = 2u;
    var first_light = -1.0;
    for (var i = 0u; i < rays; i++) {
        var a = turn + f32(i) * 3.14159265;
        var r = 0.7 * SUN_RADIUS;
        if (i >= 2u) {
            let k = f32(i - 2u);
            a = turn + 1.5707963 + k * 2.3999632;
            r = sqrt((k + 0.5) / 6.0) * SUN_RADIUS;
        }
        let dir = normalize(to_sun + (side * cos(a) + up * sin(a)) * r);
        // The objects from the surface itself; the hills from a little
        // above it, as the hills drawn near the eye are smoothed a few
        // inches off the ones the rays see, and would shade themselves.
        let things = ray(origin, dir, mask & ~TERRAIN, spread, flags);
        var hills = Ray(1.0, 0.0);
        if ((mask & TERRAIN) != 0u && things.light > 0.0) {
            hills = ray(origin + vec3<f32>(0.0, TERRAIN_LIFT, 0.0), dir, TERRAIN, spread, RAY_FLAG_CULL_NO_OPAQUE);
        }
        let got = things.light * hills.light;
        light += got;
        let first = select(hills.shade, things.shade, things.shade > 0.0);
        if (first > 0.0) {
            shade += first;
            shaded += 1.0;
        }
        if (i == 0u) {
            first_light = got;
        }
        if (i == 1u && abs(got - first_light) > 0.25) {
            rays = 8u;
        }
    }
    textureStore(traced, vec2<i32>(id.xy), vec4<f32>(light / f32(rays), dist, shade / max(shaded, 1.0), on_moving(world, to_eye, dist, vec2<i32>(id.xy))));
}
