// ImHex 1.34.0 Pattern File
// Author: C3pa
// Description: MGE XE distantland/world file pattern
// Ported from: https://github.com/Greatness7/binary_templates/blob/master/world.bt

#include <std/mem.pat>
#include <std/sys.pat>
#include <type/float16.pat>

#include <math.hexpat>

#pragma array_limit 0xFFFFFFFF
#pragma pattern_limit 0xFFFFFF

struct CompressedVertex {
	Vector3 location;
	type::float16 texCoord[2];
} [[static]];

struct TriangleLarge {
	u32 indices[3];
} [[static]];

struct Mesh {
	BoundingSphere boundingSphere;
	BoundingBox boundingBox;
	u32 numVertices;
	u32 numTriangles;
	CompressedVertex vertices[numVertices];
	if (numVertices > 0xFFFF || numTriangles > 0xFFFF) {
		TriangleLarge triangles[numTriangles];
	}
	else {
		Triangle triangles[numTriangles];
	}
};


u32 numMeshes @ 0x00;
Mesh meshes[numMeshes] @ 0x04;

std::assert_warn(std::mem::eof(), "End of file not reached");
