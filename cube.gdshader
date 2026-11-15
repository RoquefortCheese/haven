shader_type spatial;
render_mode unshaded;

void fragment() {
	for (int ch = 0; ch < 3; ch++) {
		ALBEDO[ch] = clamp(abs(mod(TIME * 0.3 + float(ch) / 3., 1.) - 0.5) * 6. - 1., 0., 1.);
	}
}
