shader_type fog;

uniform vec3 size = vec3(1.0, 1.0, 1.0);
uniform vec3 albedo : source_color = vec3(1.0);
uniform vec3 emission : source_color = vec3(1.0);
uniform float density : hint_range(-8.0, 8.0, 0.01) = 1.0;
uniform float height_falloff : hint_range(0.0, 1000000.0, 0.001) = 0.0;
uniform float edge_fade : hint_range(0.0, 1000000.0, 0.001) = 0.100;
uniform sampler3D density_texture: hint_default_white;
uniform mat4 inv_model_mat;

void fog() {
	vec3 object_position = (inv_model_mat * vec4(WORLD_POSITION, 1.0)).xyz;
	vec3 half_size = size / 2.0;
	vec3 q = abs(object_position.xyz) - half_size;
	float dist = length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
	
	if (dist < 0.0)
	{
		DENSITY = density * clamp(exp2(-height_falloff * (object_position.y)), 0.0, 1.0);
		DENSITY *= texture(density_texture, UVW).r;
		DENSITY *= pow(clamp(-2.0 * dist / min(min(SIZE.x, SIZE.y), SIZE.z), 0.0, 1.0), edge_fade);
		
	}
	else
	{
		DENSITY = 0.0;
	}
	
	ALBEDO = albedo;
}