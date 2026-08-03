module betterc.cstring;

public import core.stdc.string;

import betterc.stdio : snprintf;
import betterc.stdlib : duplicate_array;

extern (C) nothrow pure
struct Cstring
{
	size_t length = 0;
	char* start = null;

	this(char* start, size_t length)
	{
		this.start = start;
		this.length = length;
	}

	this(string str)
	{
		this.start = duplicate_array(str).ptr;
		this.length = str.length;
	}

	this(ubyte[] buffer)
	{
		this.length = buffer.length;
		this.start = cast(char*) buffer.ptr;
	}

	string toString() const
	{
		if (start == null || length == 0)
			return "";

		return cast(string) start[0 .. length];
	}
}

string toString(T)(T val)
{
	static if (is(T == string))
	{
		if (buf.length < val.length)
			return buf[0 .. 0];
		buf[0 .. val.length] = val[];
		return buf[0 .. val.length];
	}
	else static if (is(T == int))
	{
		int len = snprintf(buf.ptr, buf.length, "%d", val);
		if (len < 0 || cast(size_t) len >= buf.length)
			return buf[0 .. 0];
		return buf[0 .. cast(size_t) len];
	}
	else static if (is(T == double))
	{
		int len = snprintf(buf.ptr, buf.length, "%f", val);
		if (len < 0 || cast(size_t) len >= buf.length)
			return buf[0 .. 0];
		return buf[0 .. cast(size_t) len];
	}
	else static if (__traits(hasMember, T, "toString"))
	{
		return val.toString(buf);
	}
}
