module test.betterc.algorithm;

import betterc.algorithm;

import betterc.convert;
import betterc.stdio : print;

unittest
{
	ubyte[] needle1 = "LIST".asBytes;
	ubyte[] needle2 = "DATA".asBytes;
	ubyte[] needle3 = "not ".asBytes;
	ubyte[] haystack = "LISTnotDATA".asBytes;

	print("Testing betterc.algorithm");

	print("Testing Function startsWith");
	assert(haystack.startsWith(needle1));
	assert(haystack.startsWith(needle3) == false);
	print("Testing Function endsWith");
	assert(haystack.endsWith(needle2));
	assert(haystack.endsWith(needle1) == false);

	print("betterc.algorithm works fine");
}
