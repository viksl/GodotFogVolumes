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
	float inv_height = 1.0 / max(0.001, half_size.y);
	float radius = 1.0 / max(0.001, (min(half_size.x, half_size.z) * 0.5));
	float hypotenuse = sqrt(radius * radius + inv_height * inv_height);
	float rsin = radius / hypotenuse;
	float rcos = inv_height / hypotenuse;
	vec2 c = vec2(rsin, rcos);

	float q = length(object_position.xz);
	float dist = max(dot(c, vec2(q, object_position.y - half_size.y)), -half_size.y - object_position.y);
	
	if (dist < 0.0)
	{
		DENSITY = density * clamp(exp2(-height_falloff * object_position.y), 0.0, 1.0);
		DENSITY *= texture(density_texture, UVW).r;
		DENSITY *= pow(clamp(-2.0 * dist / min(min(SIZE.x, SIZE.y), SIZE.z), 0.0, 1.0), edge_fade);
	}
	else
	{
		DENSITY = 0.0;
	}
	
	ALBEDO = albedo;
	EMISSION = emission;
}
