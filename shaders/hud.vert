/*
/ Copyright � 2010
/ Andrew Flower & Justin Crause
/ Honours Project - Deformable Terrain
*/
#version 150 core

uniform vec2 offset;
uniform mat2 transform;

// Shader Input
in vec2 vert_Position;
in vec2 vert_TexCoord;

out vec2 frag_TexCoord;

//------------------------------------------------------------------------------
void main(){
	gl_Position 	= vec4(transform * vert_Position + offset, 1.0, 1.0);
	frag_TexCoord	= vert_TexCoord;
}
