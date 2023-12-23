// ImHex 1.31.0 Pattern File
// Author: C3pa
// Description: MGE XE distantland/statics/usage.data

#include <std/mem.pat>
#include <std/sys.pat>
#include <std/io.pat>


#pragma endian little
//#pragma debug

#pragma once


///////////////////////
// Begin: math.hexpat
///////////////////////

struct Vector3 {
	float x, y, z;
} [[static, format("format_Vector3")]];

fn format_Vector3(Vector3 v) {
	return std::format("({:.3f}, {:.3f}, {:.3f})", v.x, v.y, v.z);
};

///////////////////////
// Begin: distantland.hexpat
///////////////////////

namespace DynamicVisGroup {
	enum DataSource : u8 {
		Journal = 1,
		Global = 2,
		UniqueObject = 3,
	};

	struct Range {
		s32 begin, end;
	} [[static]];

	// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/src/mge/distantland.h#L26
	struct DynamicVisGroup {
		DataSource source;
		// bool enabled = true;
		// const void *gameObject;
		char id[64];
		u8 rangeCount;
		Range ranges[8]; // std::vector<Range> ranges;
		//QuadTreeMesh references[]; // std::vector<QuadTreeMesh*> references;
	};// [[static]];
}

///////////////////////
// End: distantland.hexpat
///////////////////////

struct Reference {
	u32 id;
	u16 visIndex;
	Vector3 location;
	// yaw, pitch, roll
	Vector3 rotation;
	float scale;
} [[static]];

struct Exterior {
	u32 numReferences;
	Reference references[numReferences];
};

struct Interior {
	u32 numReferences;
	if (numReferences) {
		char cellName[64];
		Reference references[numReferences];
	}
};


fn getNumInts(u128 offset) {
	u32 numInts = 0;

	while (true) {
		u32 numReferences = std::mem::read_unsigned(offset, 4);
		offset += 4;
		if (numReferences > 0) {
			// char cellName[64];
			offset += 64;
			offset += numReferences * 34;
			numInts += 1;
			continue;
		}
		break;
	}

	return numInts;
};


// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/src/mge/distantinit.cpp#L836
u32 DistantStaticCount @ $;

// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/src/mge/distantinit.cpp#L952
u32 dynamicVisGroupCount @ $;
DynamicVisGroup::DynamicVisGroup visGroups[dynamicVisGroupCount] @ $;

Exterior exterior @ $;

u32 numInteriors = getNumInts($);
Interior interiors[numInteriors] @ $;

// MGEgui//DistantLand//DistantLandForm.csL1356
s32 terminator @ $ [[comment("Unused")]];
float minStaticSize @ $;

std::assert_warn(std::mem::eof(), "End of file not reached");
