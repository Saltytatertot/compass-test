shader_type spatial;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

global uniform vec3 OCEAN_POSITION; // Global shader value for the player position


uniform vec4 albedo : source_color;
uniform vec4 albedo2 : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 1.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.525;

uniform sampler2D wave;
uniform sampler2D wave_bump; // Normal bump map version of the noise wave texture
uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;
uniform float wave_time = 0;
uniform float wave_speed = 0.1;
uniform vec2 wave_direction = vec2( 2.0, 0.0 );
uniform vec2 wave_direction2 = vec2( 0.0, 1.0 );
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.1;
uniform float noise_scale = 30.0;
uniform float height_scale = 1.025;

uniform vec3 color_deep : source_color = vec3(0.11,0.29,0.33);
uniform vec3 color_shallow : source_color = vec3(0.0, 0.47, 0.76);
uniform float beers_law = 2.0;
uniform float depth_offset = 1.5;

uniform float edge_scale : hint_range(0.0, 1.0, 0.05) = 0.1;
uniform float near = 0.5;
uniform float far = 100.0;
uniform vec3 edge_color : source_color; //= vec3(1.0, 1.0, 1.0);


// Varying Variables
varying float height;
varying vec3 world_position;
varying float vertex_distance;
varying float vertex_distance_clamped;
varying vec2 vertex_position;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow( (1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount );
}

float edge( float depth )
{
	depth = 2.0 * depth - 1.0;
	return near * far / (far + depth * (near - far));
}

float waveheight(vec2 offset, int mode) 
{
	float h1 = 0.0;
	float h2 = 0.0;
	float hmix = 0.0;
	switch (mode) 
	{
	// height = texture(wave, world_position.xz / noise_scale + wave_time * wave_speed).r;
		case 0: // For getting Wave 1 Height
			h1 = texture(wave, (world_position.xz + offset) / noise_scale + wave_time * wave_speed).r;
			return h1;
		case 1: // For getting Wave 2 Height
			h2 = texture(wave, (world_position.xz + offset) / noise_scale + wave_time * wave_speed).r;
			return h2;
		case 2:	// For getting Wave 1 and Wave 2 Height Average
			h1 = texture(wave, (world_position.xz + offset) / noise_scale + wave_time * wave_speed).r;
			h2 = texture(wave, (world_position.xz + offset) / noise_scale + wave_time * wave_speed).r;
			hmix = mix(h1, h2, 0.5);
			return hmix;
	}
	return 0.0;
}

void vertex() 
{
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vertex_distance = distance(world_position,OCEAN_POSITION);
	vertex_distance = clamp(vertex_distance, 0.0, 85.0);
	vertex_distance_clamped = vertex_distance / 85.0;
	
	//height = texture(wave, world_position.xz / noise_scale + wave_time * wave_speed).r;
	float prev_height_x = waveheight(vec2(-0.3,0.0), 2);
	float next_height_x = waveheight(vec2(0.3,0.0), 2);
	float prev_height_y = waveheight(vec2(0.0,-0.3), 2);
	float next_height_y = waveheight(vec2(0.0,0.3), 2);
	float height_mix = waveheight(vec2(0.0,0.0), 2);
	
	VERTEX.y += height_mix * height_scale * (1.0 - vertex_distance_clamped);
	
	float fraction_x = fract(round(UV.x * 1000.0) / 10.0);
	float fraction_y = fract(round(UV.y * 1000.0) / 10.0);
	if (fraction_x != 0.0) {
		if (fract(UV.y) == 0.0) {
			VERTEX.y = ((prev_height_x + next_height_x) * height_scale * (1.0 - vertex_distance_clamped)) / 2.0;
		}
	}
	if (fraction_y != 0.0) {
		if (fract(UV.x) == 0.0) {
			VERTEX.y = ((prev_height_y + next_height_y) * height_scale * (1.0 - vertex_distance_clamped)) / 2.0;
		}	
	}
	
}

// Called for every pixel the material is visible on.
void fragment() 
{
//	Controls depth coloration
	float depth_texture = texture(DEPTH_TEXTURE, SCREEN_UV, 0.0).r;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth_texture);
	vec4 view = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0); 
	view.xyz /= view.w;
	float depth_blend = exp((-view.z+VERTEX.z + depth_offset) * -beers_law);
	depth_blend = clamp(1.0 - depth_blend, 0.0, 1.0);
	float depth_blend_power = clamp(pow(depth_blend, 2.5), 0.0, 1.0);
	
	vec3 screen_color = textureLod(SCREEN_TEXTURE,  SCREEN_UV, depth_blend_power * 2.5).rgb;
	vec3 depth_color = mix(color_shallow.rgb, color_deep.rgb, depth_blend_power);
	vec3 color = mix(screen_color * depth_color, depth_color * 0.05, depth_blend_power * 0.05);
	
	float z_depth = edge(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	float z_pos = edge(FRAGCOORD.z);
	float z_dif =  z_pos - z_depth;
	
//	Main shader of the water.
	vec2 time = (TIME * wave_direction) * time_scale;
	vec2 time2 = (TIME * wave_direction2) * time_scale;
	
	vec3 normal_blend = mix( texture(texture_normal, world_position.xz / noise_scale + time).rgb, texture(texture_normal2, world_position.xz + time2).rgb, 0.5 ); 
	
	vec3 wave_normal_blend = mix(texture(wave_bump, world_position.xz / noise_scale + time ).xyz, texture( wave_bump, world_position.xz / noise_scale + time2).xyz, 0.3);   
	
	float fresnel = fresnel(5.0, NORMAL, VIEW);
	vec3 surface_color = mix(albedo.rgb, albedo2.rgb, fresnel);
	
	vec3 depth_color_adj = mix(edge_color, color, step(edge_scale, z_dif));
	
	//vec3 normal = texture(texture_normal, UV).rgb;
	ALBEDO = mix( surface_color, color, 0.75 );
	//ALBEDO = clamp(surface_color + depth_color_adj, vec3(0.0), vec3(1.0));
	METALLIC = metallic;
	ROUGHNESS = roughness;
	//NORMAL_MAP = normal_blend;
	NORMAL_MAP = mix(wave_normal_blend, normal_blend, 0.5);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
