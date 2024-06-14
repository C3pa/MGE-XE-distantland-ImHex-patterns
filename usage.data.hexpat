// ImHex 1.34.0 Pattern File
// Author: C3pa
// Description: MGE XE distantland/statics/usage.data

#include <std/mem.pat>
#include <std/sys.pat>
#include <std/io.pat>

#include <math.hexpat>
#include <distantland.hexpat>

#pragma endian little
// #pragma debug

#pragma once

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
