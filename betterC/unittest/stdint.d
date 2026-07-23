module test.betterc.stdint;

import betterc.stdint;

import betterc.stdio : print;

unittest
{
	print("Testing betterc.stdint");

	print("Testing Function bit_subrange");
	assert(bit_subrange(0b_0110_1100, 2, 5) == 0b_0000_1011);
	assert(bit_subrange(0xDEAD_BEEF_CAFE_BABE, 0, 63) == 0xDEAD_BEEF_CAFE_BABE);
	assert(bit_subrange(0xDEAD_BEEF_CAFE_BABE, 4, 63) == 0x0DEA_DBEE_FCAF_EBAB);

	print("betterc.stdint works fine");
}
