module betterc.cstring;

public import core.stdc.string;

import betterc.stdio : snprintf;
import betterc.stdlib : duplicate_array, allocate_array, copy_array;

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

	this(char[] buffer)
	{
		this.length = buffer.length;
		this.start = buffer.ptr;
	}

	string toString() const
	{
		if (start == null || length == 0)
			return "";

		return cast(string) start[0 .. length];
	}

	int opCmp(Cstring other) const
	{
		ulong minLen = this.length < other.length ? this.length : other.length;
		int cmp = memcmp(this.start, other.start, cast(size_t) minLen);

		if (cmp != 0)
			return cmp;

		if (this.length < other.length)
			return -1;

		if (this.length > other.length)
			return 1;

		return 0;
	}

	bool opEquals(Cstring other) const
	{
		return this.opCmp(other) == 0;
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

Cstring[] splitByFirst(Cstring input, char delimiter)
{
	for (size_t i = 0; i < input.length; i++)
	{
		if (input.start[i] == delimiter)
		{
			Cstring[] result = allocate_array!Cstring(2);
			result[0] = Cstring(copy_array(input.toString(), 0, i));
			result[1] = Cstring(copy_array(input.toString(), i + 1, input.length));
			return result;
		}
	}

	Cstring[] result = allocate_array!Cstring(1);
	result[0] = input;
	return result;
}
