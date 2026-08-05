module betterc.stdint;

const ubyte ULONG_BIT_COUNT = 64;
const ubyte UINT_BIT_COUNT = 32;
const ubyte USHORT_BIT_COUNT = 16;
const ubyte UBYTE_BIT_COUNT = 8;

pure nothrow @safe @nogc
ulong bit_subrange(const ulong value, const ubyte start, const ubyte end)
{
	if (start > end || end >= ULONG_BIT_COUNT)
	{
		return 0;
	}

	if (end == (ULONG_BIT_COUNT - 1))
	{
		return value >> start;
	}

	const ulong mask = (1UL << (end + 1)) - 1;
	return (value & mask) >> start;
}

pure nothrow @safe @nogc
uint bit_subrange(const uint value, const ubyte start, const ubyte end)
{
	if (start > end || end >= UINT_BIT_COUNT)
	{
		return 0;
	}

	if (end == (UINT_BIT_COUNT - 1))
	{
		return value >> start;
	}

	const uint mask = (1U << (end + 1)) - 1;
	return (value & mask) >> start;
}
