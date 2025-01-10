#version 430
layout (location = 0) in vec4 vertex;
out vec2 TexCoords;
uniform int songinfo;
uniform float time;


void main()
{
    vec4 pos = vec4(vertex.xy, 0.0, 1.0);
    gl_Position = pos;
	if (songinfo != 0) {
		if (pos.y > 0) {
			gl_Position.xy += vec2(1, -1);
			gl_Position.xy *= 0.3;
			gl_Position.x -= 0.95;
			gl_Position.y -= 0.85;
		} else {
			gl_Position.xy += vec2(1, 1);
			gl_Position.xy *= 0.2;
			gl_Position.x -= 0.95;
			gl_Position.y -= 0.9;
		}
	}
    TexCoords = vertex.zw;
}
