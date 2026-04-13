// Created by Ryan Remer
// https://godotshaders.com/shader/gradienttexture-shader/
// edited by me with a few additions im pretty dumb when it comes to shader code so its mostly copied from other shaders and a frankenstine of a shader
shader_type spatial;
uniform sampler2D color_ramp : source_color;

uniform float curve_strength = 0.001;


void light() {
	float dotnl = dot(NORMAL, LIGHT);
	float sample_position = max((dotnl + 1.0) / 2.01, 0.01);
	vec4 ramp_light = texture(color_ramp, vec2(sample_position, 0.0));
	vec3 diffuse_light = ramp_light.rgb * clamp(LIGHT_COLOR * ATTENUATION, vec3(0,0,0), vec3(1,1,1));
	DIFFUSE_LIGHT = max(diffuse_light, DIFFUSE_LIGHT);
}