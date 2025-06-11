shader_type spatial;
render_mode cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D Albedo_Tex;
uniform sampler2D Noise_Tex;
uniform sampler2D Emissive_Tex;
uniform sampler2D Roughness_Tex;
uniform sampler2D Normal_Tex;

uniform float Emission_Strength : hint_range(0, 10) = 2.0;
uniform float Noise_Speed = 0.5;

float hash(float x) {
    return fract(sin(x) * 43758.5453);
}


float smooth_noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    // animované UV posunutí
	float offset_x = smooth_noise(UV * 10.0 + vec2(TIME * Noise_Speed));
	float offset_y = smooth_noise(UV * 10.0 + vec2(TIME * Noise_Speed * 0.5));
	vec2 animated_uv = UV + vec2(offset_x, offset_y) * 0.1; // malý posun
	
    // vzorkování textur
    vec3 albedo = texture(Albedo_Tex, animated_uv).rgb;
    float noise = texture(Noise_Tex, animated_uv).r;
    vec3 emissive = texture(Emissive_Tex, animated_uv).rgb;
    float roughness = texture(Roughness_Tex, animated_uv).r;
    vec3 normal_map = texture(Normal_Tex, animated_uv).rgb;

    // normálová mapa do správného rozsahu (-1..1)
    vec3 normal = normalize(normal_map * 2.0 - 1.0);
    NORMAL_MAP = normal;

    // barva s přidaným noise (modulace)
    ALBEDO = albedo * noise;

    // roughness z textury
    ROUGHNESS = roughness;

    // emise s intenzitou a noise, aby láva žhnula víc na některých místech
    EMISSION = emissive * noise * Emission_Strength;
}