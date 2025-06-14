shader_type spatial;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float star(vec2 uv, vec2 pos, float size) {
    float dist = length(uv - pos);
    return smoothstep(size, 0.0, dist);
}

void fragment() {
    vec2 uv = UV;

    vec3 color = vec3(0.001, 0.004, 0.01);

    int starsCount = 10;
    float interval = 10.0;
    float seed = floor(TIME / interval);

    for (int x = 0; x < starsCount; x++) {
        for (int y = 0; y < starsCount; y++) {
            vec2 gridPos = vec2(float(x), float(y)) / float(starsCount);
            
            float rndX = random(gridPos * 1000.0 + vec2(seed, seed));
            float rndY = random(gridPos * 2000.0 + vec2(seed, seed));
            float rndSize = random(gridPos * 3000.0 + vec2(seed, seed));
            
            vec2 starPos = gridPos + vec2(rndX * 0.9, rndY * 0.9) / float(starsCount);
            float size = 0.003 + 0.01 * rndSize;

            float flicker = 0.5 + 0.5 * sin(TIME * 3.0 + (rndX + rndY) * 6.28318);

            float tInInterval = fract(TIME / interval);
            float appear = smoothstep(0.0, 0.1, tInInterval) * smoothstep(1.0, 0.9, tInInterval);

            float brightness = star(uv, starPos, size) * flicker * appear;
            color += vec3(brightness);
        }
    }

    ALBEDO = color;
}
