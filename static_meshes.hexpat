// ImHex 1.35.4 Pattern File
#pragma author C3pa
#pragma description Pattern for MGE XE MGE XE distantland/statics/static_meshes file.
#pragma version 1.0.0
#pragma once
#pragma endian little
#pragma array_limit 0xFFFFFFFF
#pragma pattern_limit 0xFFFFFF
#pragma loop_limit 0xFFFFFFFF


import std.math;
import std.sys;
import type.float16;

import dlformat;
import math;


DistantStatic statics[while(!std::mem::eof())] @ $;

std::assert_warn(std::mem::eof(), "End of file not reached");
