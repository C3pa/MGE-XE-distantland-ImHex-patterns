#pragma once

import std.io;
import type.float16;

struct Vector2 {
	float x, y;
} [[static, format("format_Vector2")]];

fn format_Vector2(ref Vector2 v) {
	return std::format("({:.3f}, {:.3f})", v.x, v.y);
};

struct HalfVector3 {
	type::float16 x, y, z;
} [[static]];

struct Vector3 {
	float x, y, z;
} [[static, format("format_Vector3")]];

fn format_Vector3(ref Vector3 v) {
	return std::format("({:.3f}, {:.3f}, {:.3f})", v.x, v.y, v.z);
};

struct Triangle {
	u16 x, y, z;
} [[static]];

fn format_Triangle(ref Triangle t) {
	return std::format("({}, {}, {})", t.x, t.y, t.z);
};

struct BoundingSphere {
	float radius;
	Vector3 center;
} [[static]];

struct BoundingBox {
	Vector3 min;
	Vector3 max;
} [[static]];
