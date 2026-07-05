module convert;

import core.stdc.stdlib : malloc, free;
import core.stdc.stdio : snprintf;

string join_array(string[] arr, string delim = ", ")
{
    if (arr.length == 0)
    {
        char* buffer = cast(char*)malloc(2);
        if (!buffer) return null;
        buffer[0] = '[';
        buffer[1] = ']';
        return cast(string)buffer[0 .. 2];
    }

    size_t totalLen = 2;
    foreach (i, s; arr)
    {
        totalLen += s.length;
        if (i < arr.length - 1)
        {
            totalLen += delim.length;
        }
    }

    char* buffer = cast(char*)malloc(totalLen);
    if (!buffer) return null;

    buffer[0] = '[';
    size_t offset = 1;

    foreach (i, s; arr)
    {
        foreach (j; 0 .. s.length)
        {
            buffer[offset + j] = s[j];
        }
        offset += s.length;

        if (i < arr.length - 1)
        {
            foreach (j; 0 .. delim.length)
            {
                buffer[offset + j] = delim[j];
            }
            offset += delim.length;
        }
    }

    buffer[offset] = ']';

    return cast(string)buffer[0 .. totalLen];
}

//region toString
string toString(long value)
{
    int len = snprintf(null, 0, "%lld".ptr, value);
    if (len <= 0) return null;

    char* buf = cast(char*)malloc(len + 1);
    if (!buf) return null;

    snprintf(buf, len + 1, "%lld".ptr, value);

    return cast(string)buf[0 .. len];
}

string toString(double value, int precision = 6)
{
    int len = snprintf(null, 0, "%.*f".ptr, precision, value);
    if (len <= 0) return null;

    char* buf = cast(char*)malloc(len + 1);
    if (!buf) return null;

    snprintf(buf, len + 1, "%.*f".ptr, precision, value);

    return cast(string)buf[0 .. len];
}

string toString(ubyte value)
{
    char[3] buffer;
    snprintf(buffer.ptr, buffer.length, "%02x", value);
    return buffer[0 .. 2].idup;
}

string toString(const ubyte[] values)
{
    if (values.length == 0) return [];

    auto hexArrStorage = cast(string*)malloc(values.length * string.sizeof);
    if (!hexArrStorage) return null;
    string[] hexArr = hexArrStorage[0 .. values.length];

    foreach (i, val; values)
    {
        char* buf = cast(char*)malloc(3);
        if (!buf) return null;
        snprintf(buf, 3, "%02x", val);
        hexArr[i] = cast(string)buf[0 .. 2];
    }

    string result = join_array(hexArr, ", ");

    foreach (s; hexArr)
    {
        free(cast(void*)s.ptr);
    }
    free(hexArr.ptr);

    return result;
}
//endregion
//region asBytes
ubyte[] asBytes(string text)
{
    return cast(ubyte[]) text;
}
//endregion
ulong asUlong(ubyte[8] bytes, bool little_endian = true)
{
	if (little_endian)
	{
		return (cast(ulong)bytes[0])       |
			(cast(ulong)bytes[1] << 8)  |
			(cast(ulong)bytes[2] << 16) |
			(cast(ulong)bytes[3] << 24) |
			(cast(ulong)bytes[4] << 32) |
			(cast(ulong)bytes[5] << 40) |
			(cast(ulong)bytes[6] << 48) |
			(cast(ulong)bytes[7] << 56);
    }
    else
    {
		return (cast(ulong)bytes[7])       |
			(cast(ulong)bytes[6] << 8)  |
			(cast(ulong)bytes[5] << 16) |
			(cast(ulong)bytes[4] << 24) |
			(cast(ulong)bytes[3] << 32) |
			(cast(ulong)bytes[2] << 40) |
			(cast(ulong)bytes[1] << 48) |
			(cast(ulong)bytes[0] << 56);
	}
}

uint asUint(ubyte[4] bytes, bool little_endian = true)
{
	if (little_endian)
	{
		return (cast(uint)bytes[0])       |
			(cast(uint)bytes[1] << 8)  |
			(cast(uint)bytes[2] << 16) |
			(cast(uint)bytes[3] << 24);
    }
    else
    {
		return (cast(uint)bytes[3])	|
			(cast(uint)bytes[2] << 8)  |
			(cast(uint)bytes[1] << 16) |
			(cast(uint)bytes[0] << 24);
    }
}
