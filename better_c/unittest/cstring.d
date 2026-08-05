module test.betterc.cstring;

import betterc.cstring;

import betterc.stdio : print;

unittest
{
	Cstring genre = Cstring("genre");

	print("Testing betterc.cstring");

	print("Testing opCmp Cstring");
	assert(genre == Cstring("genre"));

	print("betterc.cstring works fine");
}
