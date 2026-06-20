module stdio;

import convert;

import core.stdc.stdio : printf;
import core.stdc.string : strlen;
import core.stdc.stdlib : malloc, free;

string[] parse_arguments(int argc, char** argv)
{
    string[] args;
	if (argc > 0)
	{
		void* mem = malloc(argc * string.sizeof);
		if (!mem) return [];

		args = (cast(string*)mem)[0 .. argc];

		foreach (i; 0 .. argc)
		{
			char* ptr = argv[i];
			size_t len = strlen(ptr);
			args[i] = cast(string)ptr[0 .. len];
		}
	}
	return args;
}

void print(string message, string end="\n")
{
    printf(message.ptr);
    printf(end.ptr);
}

void print(string[] array, string end="\n", string delim=", ")
{
    print(array.join_array(delim), end);
}
