shader_type spatial;
render_mode world_vertex_coords;
uniform sampler3D shadow;

float random(vec3 point) {
	return fract(sin(dot(point, vec3(12.9898, 78.233, 37.719))) * 43758.5453);
}

void fragment() {
	vec3 point = (INV_VIEW_MATRIX * vec4(VERTEX, 1.)).xyz;
	point = floor(point * 16. + 0.001) / 16.;
	float brightness = random(point);
	brightness -= texture(shadow, point * 0.001 + 0.5).x * 0.4;
	brightness += 0.2;
	ALBEDO = vec3(brightness);
}
