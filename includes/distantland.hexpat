#pragma once

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
