// ImHex 1.35.4 Pattern File
#pragma author C3pa
#pragma description Pattern for MGE XE distantland/version file.
#pragma version 1.0.0
#pragma once
#pragma endian little

import std.mem;
import std.sys;


u8 version @ 0x00;

std::assert_warn(std::mem::eof(), "End of file not reached");
