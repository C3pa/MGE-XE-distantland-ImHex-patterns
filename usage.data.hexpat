// ImHex 1.35.4 Pattern File
#pragma author C3pa
#pragma description Pattern for MGE XE MGE XE distantland/statics/usage.data file.
#pragma version 1.0.0
#pragma once
#pragma endian little


import std.io;
import std.mem;
import std.sys;

import math;
import distantland;


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
	char cellName[64];
	Reference references[numReferences];
};

// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/src/mge/distantinit.cpp#L836
u32 DistantStaticCount @ $;

// https://github.com/Hrnchamd/MGE-XE/blob/345ed72c115bc2a1984c649ebe615df81ae04f10/src/mge/distantinit.cpp#L952
u32 dynamicVisGroupCount @ $;
DynamicVisGroup::DynamicVisGroup visGroups[dynamicVisGroupCount] @ $;

Exterior exterior @ $;

u64 interiorEndAdress = std::mem::base_address() + std::mem::size() - 8;
Interior interiors[while($ < interiorEndAdress)] @ $;

// MGEgui//DistantLand//DistantLandForm.csL1356
s32 terminator @ $ [[comment("Unused")]];
float minStaticSize @ $;

std::assert_warn(std::mem::eof(), "End of file not reached");
