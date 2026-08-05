module betterc.algorithm;

import betterc.stdlib : malloc;
import betterc.cstring : Cstring;

pure nothrow @safe @nogc
bool startsWith(ubyte[] haystack, ubyte[] needle)
{
	if (haystack.length < needle.length)
		return false;

	for (size_t i = 0; i < needle.length; i++)
	{
		if (haystack[i] != needle[i])
			return false;
	}

	return true;
}

pure nothrow @safe @nogc
bool endsWith(ubyte[] haystack, ubyte[] needle)
{
	if (haystack.length < needle.length)
		return false;

	size_t offset = haystack.length - needle.length;

	for (size_t i = 0; i < needle.length; i++)
	{
		if (haystack[offset + i] != needle[i])
			return false;
	}

	return true;
}

void toLowercase(char[] input)
{
	foreach (ref c; input)
	{
		if (c >= 'A' && c <= 'Z')
		{
			c += 32;
		}
	}
}

void toLowercase(char* str, size_t len)
{
	if (str !is null)
	{
		toLowercase(str[0 .. len]);
	}
}

void toLowercase(Cstring input)
{
	toLowercase(input.start, input.length);
}
