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
			gl_Position.x += 0.42;
			gl_Position.y -= 1.2;
		} else {
			gl_Position.xy += vec2(1, 1);
			gl_Position.xy *= 0.8;
			gl_Position.x -= 0.58;
			gl_Position.y -= 0.35;
		}
	}
    TexCoords = vertex.zw;
}
