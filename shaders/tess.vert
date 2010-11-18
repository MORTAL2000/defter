/*
/ Copyright � 2010
/ Andrew Flower & Justin Crause
/ Honours Project - Deformable Terrain
*/

#version 150 core
#pragma optionNV unroll all
#pragma optionNV inline all

// Uniforms
uniform sampler2D heightmap;
// texToMetre = .x  ; metreToTex = .y
uniform vec2	scales;
// cam = .xy  ; shift = .zw   interleaving
uniform vec4	cam_and_shift;
uniform float	cam_height;
uniform mat4	projection;
uniform mat2	stampTransform;
uniform vec2	click_pos;
uniform mat4	mvp;


// Shader Input
in vec3 vert_Position;
in vec2 vert_TexCoord;


// Shader Output
out float mustTess;
out vec4 geom_ProjPos;
out vec2 geom_TexCoord;
out vec2 geom_StampTexCoord;


// Constansts
const vec2 const_list	= vec2(1.0,  .0);


//------------------------------------------------------------------------------
// NB:
// Clipmap is centred on origin but the origin texel has coordinate 0.5, 0.5
// the camera, starts at 0, 0
//------------------------------------------------------------------------------
void main()
{
	// Variables
	float height, lod, texToMetre, metreToTex;
	vec2 texCoord, camera_world, shift, camera_tex;
	float camera_height;

	// Extract data passed in
	camera_tex	= cam_and_shift.xy;
	shift	 	= cam_and_shift.zw;
	texToMetre	= scales.x;
	metreToTex	= scales.y;

	// Convert camera position to world space
	camera_world = camera_tex * texToMetre;

	// Compute texture coordinates for vertex and lookup height
	texCoord = vert_TexCoord + camera_tex + shift * metreToTex;

	mustTess = dot(vert_Position.xz, vert_Position.xz);

	// Get the height of vertex, and the height at the camera position
	// Vertex height samples the mipmap level corresponding to this clipmap level
	height 	= texture(heightmap, texCoord).r;
	camera_height = -cam_height;

	// Set vertex position and height from heightmap
	vec4 pos = vec4(vert_Position.x, height, vert_Position.y, 1.0);

	// Shift the roaming mesh so that vertices maintain same heights
	// The following MAD instruction shifts the x and z coordinates by s and t
	pos = pos + const_list.xyxy * shift.sttt;
	// So gl_Position contains the basic heightfield worldspace coordinate
	pos = pos + const_list.yxyy * camera_height;

	// Save out the gl_Position
	gl_Position = pos;

	// Pos contains the transformed coordinate in eye-space.
	geom_ProjPos = mvp * pos;
	
	// Save out the texCoord
	geom_TexCoord = texCoord;

	// Save out the stamps texCoord
	geom_StampTexCoord = stampTransform * (texCoord - click_pos) + 0.5;
}
