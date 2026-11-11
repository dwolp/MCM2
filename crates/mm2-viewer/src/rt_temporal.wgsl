// The ray-traced shadows over time (rt.rs): each frame's two rays a pixel
// (rt_shadow.wgsl) blended with what the frames before saw at the same
// place, so the shadows' fine detail (a rider's arms, the gaps between
// railway wagons) holds still instead of flickering. Where the place was
// not in view, or something else stood there, the new frame's own.

struct Params {
    inverse_view_proj: mat4x4<f32>,
    camera: vec4<f32>,
    to_sun: vec4<f32>,
    size: vec4<f32>,
    // The frame before's view and projection, and x 1 when the history
    // holds a frame before, yzw where its camera was.
    previous: mat4x4<f32>,
    history: vec4<f32>,
};

@group(0) @binding(0) var<uniform> params: Params;
@group(0) @binding(1) var raw: texture_2d<f32>;
@group(0) @binding(2) var before: texture_2d<f32>;
@group(0) @binding(3) var depth: texture_depth_2d;
@group(0) @binding(4) var blended: texture_storage_2d<rgba16float, write>;
// For a pixel on a moving model (rt_shadow.wgsl): where it was on screen a
// frame ago, in pixels from here, how far from that frame's camera, and
// whether it is known.
@group(0) @binding(5) var motion: texture_2d<f32>;

// How much of the frames before is kept: about the last five.
const KEEP: f32 = 0.8;

@compute @workgroup_size(8, 8)
fn blend(@builtin(global_invocation_id) id: vec3<u32>) {
    let size = vec2<i32>(params.size.xy);
    let p = vec2<i32>(id.xy);
    if (p.x >= size.x || p.y >= size.y) {
        return;
    }
    let now = textureLoad(raw, p, 0);
    if (now.y > 50000.0 || params.history.x < 0.5) {
        textureStore(blended, p, now);
        return;
    }
    // Where this pixel's surface was on the screen a frame ago.
    let d = textureLoad(depth, p, 0);
    let ndc = vec2<f32>((f32(p.x) + 0.5) / params.size.x * 2.0 - 1.0, 1.0 - (f32(p.y) + 0.5) / params.size.y * 2.0);
    let h = params.inverse_view_proj * vec4<f32>(ndc, d, 1.0);
    let world = h.xyz / h.w;
    let was = params.previous * vec4<f32>(world, 1.0);
    if (was.w <= 0.0) {
        textureStore(blended, p, now);
        return;
    }
    var uv = vec2<f32>(was.x / was.w * 0.5 + 0.5, 0.5 - was.y / was.w * 0.5);
    var then = length(params.history.yzw - world);
    // On a moving model, where it moved to, not where the camera's move
    // alone would put it.
    if (now.w > 0.5) {
        let m = textureLoad(motion, p, 0);
        if (m.w < 0.5) {
            textureStore(blended, p, now);
            return;
        }
        uv = ((vec2<f32>(p) + 0.5) + m.xy) / params.size.xy;
        then = m.z;
    }
    let q = vec2<i32>(floor(uv * params.size.xy));
    if (any(q < vec2<i32>(0)) || any(q >= size)) {
        textureStore(blended, p, now);
        return;
    }
    let old = textureLoad(before, q, 0);
    // Something else stood there, if it was not as far from the camera
    // of the frame before as this place is.
    let moved = abs(old.y - then);
    if (moved > 0.04 * now.y + 0.4) {
        textureStore(blended, p, now);
        return;
    }
    // Kept only within what the pixels round about see now, so a shadow
    // that moves leaves no trail.
    var low = now.x;
    var high = now.x;
    for (var y = -1; y <= 1; y++) {
        for (var x = -1; x <= 1; x++) {
            let t = textureLoad(raw, clamp(p + vec2<i32>(x, y), vec2<i32>(0), size - 1), 0).x;
            low = min(low, t);
            high = max(high, t);
        }
    }
    let kept = clamp(old.x, low, high);
    textureStore(blended, p, vec4<f32>(mix(now.x, kept, KEEP), now.y, now.z, 0.0));
}
