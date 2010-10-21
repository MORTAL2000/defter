/*****************************************************************************
 * Header: clipmap
 *
 * Copyright � 2010
 * Authors: Andrew Flower & Justin Crause
 * Emails:	andrew.flower@gmail.com & juzzwuzz@gmail.com
 *****************************************************************************/

#ifndef _CLIPMAP_H_
#define _CLIPMAP_H_

struct cull_block
{
	int		count;
	int		start_index;
	vector2	bound[4];
};

class Clipmap
{
public:
	Clipmap (int nVerts, float quad_size, int levels, int heightmap_dim);
	~Clipmap ();

	bool		init			();
	void		cull			(matrix4& mvp, vector2 shift);
	void		render_inner	();
	void		render_levels	(GLuint sh);
private:
	void		create_block	(int vertstart, int width, int height, 
									std::vector<vector2> &vertices,
									std::vector<GLuint> &indices);
	void		setup_vao		(std::vector<vector2>& attribs, std::vector<vector2>& tcoords, std::vector<GLuint>& indices, 
								GLuint& vao, GLuint* vbo);

public:
	vector<cull_block> blocks;

	GLuint		m_vbo[6];
	GLuint		m_vao[2];

	int			m_min_draw_count;
	int			m_primcount;
	GLsizei		m_draw_count[128];
	GLuint		m_draw_starts[128];

	int			m_N;		// clipmap dim (verts)
	int			m_M;		// block size
	int			m_nLevels;
	int			m_heightmap_dim;

	int			m_nInnerIndices;

	float		m_quad_size;
	float		m_texel_size;
	float		m_tex_to_metre;
	float		m_metre_to_tex;

	bool 		m_cullingEnabled;

	string		m_clipmap_stats;
};

#endif
