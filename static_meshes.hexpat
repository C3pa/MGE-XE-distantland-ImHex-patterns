// ImHex 1.31.0 Pattern File
// Author: C3pa
// Description: MGE XE distantland/statics/static_meshes

#include <std/mem.pat>
#include <std/sys.pat>
#include <type/float16.pat>

#include <dlformat.hexpat>
#include <math.hexpat>

#pragma endian little
#pragma array_limit 0xFFFFFFFF
#pragma pattern_limit 0xFFFFFF
#pragma loop_limit 0xFFFFFFFF

// https://github.com/Hrnchamd/MGE-XE/blob/master/MGEgui/DistantLand/DistantLandForm.cs#L1370
fn getStaticCount(u128 offset) {
	u128 count = 0;
    u128 eof = sizeof($);

	u32 sizeofBoundingSphere = sizeof(BoundingSphere);
    u32 sizeofStaticType = sizeof(StaticType);
    u32 sizeofBoundingBox = sizeof(BoundingBox);
    u32 sizeofTriangle = sizeof(Triangle);
    u32 sizeofChar = sizeof(char);

	while(offset < eof) {
		u32 numSubsets = std::mem::read_unsigned(offset, 4);
		offset += 4;

		offset += sizeofBoundingSphere;
		offset += sizeofStaticType;

		for (u32 i = 0, i < numSubsets, i += 1) {
			offset += sizeofBoundingSphere;
			offset += sizeofBoundingBox;

			u32 numVertices = std::mem::read_unsigned(offset, 4);
			offset += 4;
			u32 numTriangles = std::mem::read_unsigned(offset, 4);
			offset += 4;
			offset += 20 * numVertices; // CompressedVertex array
			offset += sizeofTriangle * numTriangles;
			offset += 2; // flags
			u16 pathSize = std::mem::read_unsigned(offset, 2);
			offset += 2;
			offset += sizeofChar * pathSize; // textureName
		}

		count += 1;
	}

	return count;
};


u128 numStatics = getStaticCount($);
std::print("Static meshes read: {}", numStatics);

DistantStatic statics[numStatics] @ 0x00;

std::assert_warn(std::mem::eof(), "End of file not reached");
