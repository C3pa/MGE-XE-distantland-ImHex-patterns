#pragma once

#include <std/math.pat>
#include <std/sys.pat>
#include <type/float16.pat>

#include <math.hexpat>

enum StaticType : u8 {
	STATIC_AUTO = 0,
	STATIC_NEAR = 1,
	STATIC_FAR = 2,
	STATIC_VERY_FAR = 3,
	STATIC_GRASS = 4,
	STATIC_TREE = 5,
	STATIC_BUILDING = 6
};

// Colors in range 0 - 255
struct ColorBGRA {
	u8 b;
	u8 g;
	u8 r;
	// 255 for fully opaque
	u8 a [[color("07687A")]];
} [[static, color(std::format("{:02X}{:02X}{:02X}", r, g, b))]];

// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/MGEfuncs/DXVertex.h#L13
struct CompressedVertex {
	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L275
	HalfVector3 position;
	// The fourth value is always 1.0f
	type::float16 pad [[hidden]];
	std::assert_warn(
		// 0x3C00 is 1.0f in half precision
		pad == 0x3C00,
		std::format("Expected 0x3C00 padding, got 0x{:X}. The pattern may be incorrect.", pad)
	);

	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L284
	u8 normal[3];
	// Average emissive color is the fourth value in normal array:
	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L288
	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L529
	u8 emissiveAverage;
	ColorBGRA diffuse;
	type::float16 texCoord[2];
} [[static]];

// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/MGEfuncs/NifConverter.cpp#L88
struct Subset {
	BoundingSphere boundingSphere;
	BoundingBox boundingBox;
	u32 numVertices;
	u32 numTriangles;
	CompressedVertex vertices[numVertices];
	Triangle triangles[numTriangles];

	// Flags
	bool alphaTestOrBlendEnabled;
	// Nodes with "mge.distant.scroll" NiStringExtraData
	bool hasUVController;

	u16 pathSize;
	// Let's not include the '\0'
	char textureName[pathSize - 1];
	padding[1];
};

// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L749
struct DistantStatic {
	u32 numSubsets;
	BoundingSphere boundingSphere;
	StaticType staticType;
	Subset subsets[numSubsets];
} [[name(std::format("{}", staticType))]];
