// ImHex 1.35.4 Pattern File
// Ported from: https://github.com/Greatness7/binary_templates/blob/master/world.bt
#pragma author C3pa
#pragma description Pattern for MGE XE distantland/world file.
#pragma version 1.0.0
#pragma once
#pragma endian little
#pragma array_limit 0xFFFFFFFF
#pragma pattern_limit 0xFFFFFF


import std.mem;
import std.sys;
import type.float16;

import math;


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
