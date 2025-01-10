
#version 430
uniform vec2 resolution;
uniform float time;
uniform sampler1D samples;
uniform sampler1D fft;
out vec4 color;

void main() {
	vec2 uv = gl_FragCoord.xy / resolution;
	color = vec4(1-mod(time-uv.x, 1.0), 0, 0, 1);
}
