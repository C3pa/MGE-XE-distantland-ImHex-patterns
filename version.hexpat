// ImHex 1.34.0 Pattern File
// Author: C3pa
// Description: MGE XE distantland/version

#include <std/mem.pat>
#include <std/sys.pat>


u8 version @ 0x00;

std::assert_warn(std::mem::eof(), "End of file not reached");
