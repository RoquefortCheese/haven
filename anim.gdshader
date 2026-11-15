shader_type spatial;
render_mode unshaded, cull_disabled;
uniform sampler2D animation;
uniform int frames;
uniform vec2 resolution;
uniform float fps;
// i know there's already a way to implement animations in godot but i don't want to learn it

void fragment() {
	int frame = int(mod((TIME * fps), float(frames)));
	vec2 point = UV;
	point = floor(point * resolution) / resolution;
	point.x += float(frame);
	point.x /= float(frames);
	vec4 sample = texture(animation, point);
	ALBEDO = sample.rgb;
	ALPHA = floor(sample.a);
}
