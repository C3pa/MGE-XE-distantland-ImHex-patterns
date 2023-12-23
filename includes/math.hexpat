#pragma once

#include <std/io.pat>

#include <type/float16.pat>

struct Vector2 {
	float x, y;
} [[static, format("format_Vector2")]];

fn format_Vector2(Vector2 v) {
	return std::format("({:.3f}, {:.3f})", v.x, v.y);
};

struct HalfVector3 {
	type::float16 x, y, z;
} [[static]];

struct Vector3 {
	float x, y, z;
} [[static, format("format_Vector3")]];

fn format_Vector3(Vector3 v) {
	return std::format("({:.3f}, {:.3f}, {:.3f})", v.x, v.y, v.z);
};

struct Triangle {
	u16 x, y, z;
} [[static]];

fn format_Triangle(Triangle t) {
	return std::format("({}, {}, {})", t.x, t.y, t.z);
};

struct BoundingSphere {
	float radius;
	Vector3 center;
};

struct BoundingBox {
	Vector3 min;
	Vector3 max;
};
