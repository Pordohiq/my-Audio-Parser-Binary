module betterc.stdio;

import betterc.convert;

public import core.stdc.stdio;
import core.stdc.string : strlen;
import core.stdc.stdlib : malloc, free;

string[] parse_arguments(int argc, char** argv)
{
	string[] args;
	if (argc > 0)
	{
		void* mem = malloc(argc * string.sizeof);
		if (!mem)
			return [];

		args = (cast(string*) mem)[0 .. argc];

		foreach (i; 0 .. argc)
		{
			char* ptr = argv[i];
			size_t len = strlen(ptr);
			args[i] = cast(string) ptr[0 .. len];
		}
	}
	return args;
}

//region PRINT
void print(string message, string end = "\n")
{
	printf(message.ptr);
	printf(end.ptr);
}

void print(string[] array, string end = "\n", string delim = ", ")
{
	print(array.join_array(delim), end);
}

void print(bool value, string end = "\n")
{
	print(value ? "true" : "false", end);
}
//endregion
//region FILES
version (Windows)
{
	extern (C) nothrow @nogc
	int _fseeki64(FILE* stream, long offset, int origin);
}
else version (Posix)
{
	extern (C) nothrow @nogc
	int fseeko(FILE* stream, long offset, int whence);
}

enum FileMode
{
	READ_BYTES = "rb",
	WRITE_BYTES = "wb",
	READ_TEXT = "r",
	WRITE_TEXT = "w"
}

nothrow @nogc
bool file_exists(string path)
{
	FILE* fp = fopen(path.ptr, "r");

	bool exists = (fp != null);
	if (exists)
		fclose(fp);

	return exists;
}

long get_file_size(string filename)
{
	FILE* fp = fopen(filename.ptr, "rb");
	if (!fp)
		return -1;

	fseek(fp, 0, SEEK_END);
	long size = ftell(fp);

	fclose(fp);
	return size;
}

/// Reads the entire File at the path in rb mode 
/// and returns the slice to the allocated heap
/// array that it filled with the file contents.
ubyte[] read_file_bytes(string path)
{
	long f_size = get_file_size(path);
	if (!path.file_exists || f_size < 0)
	{
		return [];
	}

	FILE* file = fopen(path.ptr, "rb");

	ubyte[] buffer;
	void* mem = malloc(cast(size_t) f_size);

	if (!mem)
	{
		fclose(file);
		return [];
	}

	buffer = (cast(ubyte*) mem)[0 .. cast(size_t) f_size];

	size_t bytesRead = fread(buffer.ptr, 1, buffer.length, file);
	if (bytesRead != buffer.length)
	{
		free(buffer.ptr);
		fclose(file);
		return [];
	}

	return buffer;
}

FILE* open_file(string path, FileMode fm)
{
	FILE* file = fopen(path.ptr, (cast(string) fm).ptr);
	return file;
}

ulong read_buffer(FILE* file, ubyte* buffer, ulong length, ulong offset = 0)
{
	if (!file)
		return 0;

	version (Windows)
	{
		int error = _fseeki64(file, cast(long) offset, SEEK_SET);
		if (error)
			return 0;
	}
	else version (Posix)
	{
		int error = fseeko(file, cast(long) offset, SEEK_SET);
		if (error)
			return 0;
	}

	return fread(buffer, 1, length, file);
}

void close_file(FILE* ptr)
{
	fclose(ptr);
}
//endregion
