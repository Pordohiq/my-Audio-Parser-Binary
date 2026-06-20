module stdio;

import convert;

import core.stdc.stdio : printf, FILE, fopen, fclose, ftell, fseek, SEEK_END, fread;
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

//region PRINT
void print(string message, string end="\n")
{
    printf(message.ptr);
    printf(end.ptr);
}

void print(string[] array, string end="\n", string delim=", ")
{
    print(array.join_array(delim), end);
}
//endregion
//region FILES
bool file_exists(string path)
{
    FILE *fp = fopen(path.ptr, "r");
    bool exists = (fp != null);
    if (exists) fclose(fp);
    return exists;
}

long get_file_size(string filename) {
    FILE *fp = fopen(filename.ptr, "rb");
    if (!fp) return -1;

    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);

    fclose(fp);
    return size;
}

ubyte[] read_file_bytes(string path)
{
	long f_size = get_file_size(path);
	if (!path.file_exists || f_size < 0)
	{
		return [];
	}

	FILE *file = fopen(path.ptr, "rb");

	ubyte[] buffer;
	void* mem = malloc(cast(size_t)f_size);

	if (!mem)
	{
		fclose(file);
		return [];
	}

	buffer = (cast(ubyte*)mem)[0 .. cast(size_t)f_size];

	size_t bytesRead = fread(buffer.ptr, 1, buffer.length, file);
	if (bytesRead != buffer.length)
	{
		free(buffer.ptr);
		fclose(file);
		return [];
	}

	return buffer;
}
//endregion
