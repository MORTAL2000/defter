#ifndef _RE_MODEL_H_
#define _RE_MODEL_H_

#define MESH_MAX	64

struct BoundingBox{
	vector3 min;
	vector3 max;
};

//--------------------------------------------------------
struct Mesh{
	BoundingBox		bounds;
	GLuint			tex;
	GLuint			vao;
	GLuint			vbo[4];
	int				nIndices;

	vector3			diffuse;
	vector3 		ambient;
	vector3 		specular;
	float			specPower;
};

//--------------------------------------------------------
struct Transform{
	vector3		translate;
	vector3		rotate;
	vector3		scale;
	matrix4		cache;
	bool		valid;
};

//--------------------------------------------------------
class Node{
public:
	Node	();
	Node	(Node&);	// Copy constructor
	~Node	();

	Node*	GetNode			(string name);
	void	InvalidateCache ();

public:
	Node*			m_pChild;		// First child
	Node*			m_pSibling;		// First sibling
	Mesh			m_mesh;
	Transform		m_transform;
	string			m_name;
};

//--------------------------------------------------------
Node* 		re_LoadModel			(string filename);
bool 		re_LoadChildren		(FILE* fp, Node*);
bool		re_LoadMeshData		(FILE* fp, Node*);
void		re_DeleteModelData	(Node* root);

#endif
