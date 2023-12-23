#pragma once

#include <math.hexpat>

namespace MemoryBlock {
	using MemoryPool;

	struct MemoryBlock {
		MemoryBlock next_block;
		MemoryPool owner;
		u32 next_alloc;
		char data[];
	};

	struct MemoryPool {
		MemoryBlock first_block;
		MemoryBlock last_block;
		u32 obj_size;
		u32 blk_size;
		u32 objs_per_block;
	};
}

// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/src/mge/quadtree.h#L9
struct QuadTreeMesh {
	BoundingSphere sphere;
	BoundingBox box;
	bool enabled, hasAlpha, animateUV;

	// IDirect3DTexture9* tex;
	// D3DXMATRIX transform;
	s32 verts;
	// IDirect3DVertexBuffer9* vBuffer;
	s32 faces;
	// IDirect3DIndexBuffer9* iBuffer;
};

using QuadTree;

struct QuadTreeNode {
	QuadTree owner;
	QuadTreeNode children[4];
	float box_size;
	Vector2 box_center;
	BoundingSphere sphere;
	QuadTreeMesh meshes[];
};

// quadtree.hL127
struct QuadTree {
	QuadTreeNode root;// array? [];
	MemoryPool::MemoryPool nodePool;
	MemoryPool::MemoryPool meshPool;
};
