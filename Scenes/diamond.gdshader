shader_type spatial;

render_mode blend_mix, depth_draw_opaque, cull_back, specular_schlick_ggx;

uniform vec3 albedo_color : source_color; // barva diamantu

void fragment() {
    ALBEDO = albedo_color;
    METALLIC = 1.0;
    ROUGHNESS = 0.05;
    SPECULAR = 1.0;
    ALPHA = 0.6;
}