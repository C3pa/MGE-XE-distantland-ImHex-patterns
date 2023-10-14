// ImHex 1.31.0 Pattern File
// Author: C3pa
// Description: MGE XE distantland/statics/static_meshes

#include <std/mem.pat>
#include <std/sys.pat>
#include <type/float16.pat>

#pragma endian little
#pragma array_limit 0xFFFFFFFF
#pragma pattern_limit 0xFFFFFF
#pragma loop_limit 0xFFFFFFFF


// Reference implementation of float to half-float conversion
// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/MGEfuncs/NifConverter.cpp#L47


enum StaticType : u8 {
	STATIC_AUTO = 0,
	STATIC_NEAR = 1,
	STATIC_FAR = 2,
	STATIC_VERY_FAR = 3,
	STATIC_GRASS = 4,
	STATIC_TREE = 5,
	STATIC_BUILDING = 6
};

struct HalfPoint3 {
	type::float16 x, y, z;
};

struct NiPoint3 {
	float x, y, z;
};

struct BoundingBox {
	NiPoint3 min;
	NiPoint3 max;
};

struct BoundingSphere {
	float radius;
	NiPoint3 center;
};

struct ColorBGRA {
	// Not sure in which range the colors are
	u8 b [[color("0000FF")]];
	u8 g [[color("00FF00")]];;
	u8 r [[color("FF0000")]];;
	u8 a [[color("AAAAAA")]];;
};

// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/MGEfuncs/DXVertex.h#L13
struct CompressedVertex {
	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L275
	HalfPoint3 position;
	// 1.0f padding
	type::float16 pad;

	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L284
	u8 normal[3];
	// Average emissive color is the fourth in normal array:
	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L288
	// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEfuncs/NifConverter.cpp#L529
	u8 emissiveAverage;
	ColorBGRA diffuse;
	type::float16 texCoord[2];
} [[static]];

struct Triangle {
	u16 x, y, z;
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
};

// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEgui/DistantLand/DistantLandForm.cs#L1370
fn getStaticCount() {
	u128 counter = 0;
	u128 offsetBefore = $;

	while(!std::mem::eof()) {
		u32 numSubsets = std::mem::read_unsigned($, 4);
		$ += 4;
		$ += 16; // BoundingSphere
		$ += 1; // StaticType

		for (u32 i = 0, i < numSubsets, i += 1) {
			$ += 40; // BoundingSphere + BoundingBox

			u32 numVertices = std::mem::read_unsigned($, 4);
			$ += 4;
			u32 numTriangles = std::mem::read_unsigned($, 4);
			$ += 4;
			$ += 20 * numVertices;
			$ += 6 * numTriangles;
			$ += 2; // flags
			u16 pathSize = std::mem::read_unsigned($, 2);
			$ += 2;
			$ += 1 * pathSize; // textureName
		}

		counter += 1;
	}

    $ = offsetBefore;
	return counter;
};


u128 numStatics = getStaticCount();
std::print("Static meshes read: {}", numStatics);

DistantStatic statics[numStatics] @ 0x00;

std::assert_warn(std::mem::eof(), "End of file not reached");