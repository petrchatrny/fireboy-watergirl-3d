shader_type spatial;

varying vec3 world_pos;

uniform vec4 out_color : source_color = vec4(0.0, 0.2, 1.0, 1.0);
uniform float amount : hint_range(0.2, 1.5) = 0.8;

uniform float beer_factor = 0.2;
uniform float metallic = 0.7;
uniform float roughness = 0.3;
uniform float specular = 0.5;


// náhodná trasnformace pozic X a Z souřadnic pro každý vertex
// napodobení vlnění vody
float generateOffset(float x, float z, float val1, float val2, float time) {
	float speed = 1.0;

	float radX = ((mod(x+z*x*val1,amount)/amount)+(time*speed)*mod(x*0.8+z,1.5))*2.0*3.14;
	float radZ = ((mod(val2*(z*x+x*z),amount)/amount)+(time*speed)*2.0*mod(x,2.0))*2.0*3.14;

	return amount*0.5*(sin(radZ)+cos(radX));
}

vec3 distortion(vec3 vertex, float time) {
	float xd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time);
	float yd = generateOffset(vertex.x, vertex.z, 0.1, 0.3, time);
	float zd = generateOffset(vertex.x, vertex.z, 0.15, 0.2, time);
	return vertex + vec3(xd, yd, zd);
}

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX = distortion(VERTEX, TIME*0.1);

	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// barva
	ALBEDO = out_color.rgb;

	// nasvícení vody
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX))); // pomocí parciálních derivací podle X a Y provede vektorový součin a výsledek normalizuje
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roughness;

	// průhlednost vody do určité hloubky
	// float water_depth = clamp((world_pos.y - -1.0) * beer_factor, 0.0, 1.0);
	//float absorption = exp(-water_depth);
	//ALPHA = clamp(1.0 - absorption, 0.0, 1.0);

	//float depth = texture(DEPTH_TEXTURE,SCREEN_UV).r;

	//float depth = water_depth*2.0-1.0;
	//depth = PROJECTION_MATRIX[3][2]/(depth+PROJECTION_MATRIX[2][2]);
	//depth = depth+VERTEX.z;

	//depth = exp(-depth*beer_factor);
	//ALPHA = clamp(1.0-depth,0.0,1.0);

	ALPHA = 0.9;
}

void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.

	float depth_factor = clamp((world_pos.y - -1.0) * beer_factor, 0.0, 1.0);
    float absorption = exp(-depth_factor);

    // Tlumí difúzní i spekulární složku světla (napodobuje pohlcování světla vodou)
    DIFFUSE_LIGHT *= absorption;
    SPECULAR_LIGHT *= absorption;
}
