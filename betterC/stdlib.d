module betterc.stdlib;

import core.stdc.stdlib : c_malloc = malloc, c_free = free;
public import core.stdc.stdlib;

import core.stdc.string : memcpy;

/// Allocates a dynamic array on the heap
public nothrow @system @nogc
T[] allocate_array(T)(ulong length)
{
	T* ptr = cast(T*) malloc(T.sizeof * length);

	if (!ptr)
		return [];

	return ptr[0 .. length];
}

nothrow @system @nogc
T[] copy_array(T)(const(T)[] original_array, ulong start_index, ulong end_index)
{
	if (start_index >= end_index || end_index > original_array.length)
		return [];

	ulong new_length = end_index - start_index;
	T[] new_array = allocate_array!T(new_length);
	if (new_array.ptr is null)
		return [];

	memcpy(new_array.ptr, original_array.ptr + start_index, new_length * T.sizeof);

	return new_array;
}

nothrow @system @nogc
T[] duplicate_array(T)(const(T)[] original_array)
{
	return copy_array!T(original_array, 0, original_array.length);
}

//region MEMORY
debug __gshared size_t total_heap_usage = 0;

public nothrow @system @nogc
void* allocate(size_t size, string caller = __FUNCTION__)
{
	size_t alloc_size = size;
	debug alloc_size += size_t.sizeof;

	void* ptr = c_malloc(alloc_size);
	if (!ptr)
		return null;

	void* user_ptr = ptr;

	debug
	{
		import betterc.stdio : FILE, fopen, fprintf, fclose;

		*(cast(size_t*) ptr) = size;
		user_ptr += size_t.sizeof;

		total_heap_usage += size;

		FILE* log_file = fopen("allocations_log.txt", "a");
		if (log_file)
		{
			fprintf(log_file, "ALLOC | Caller: %.*s | Addr: %p | Size: %zu bytes | Total Heap: %zu bytes\n",
				cast(int) caller.length, caller.ptr, user_ptr, size, total_heap_usage);
			fclose(log_file);
		}
	}

	return user_ptr;
}

public nothrow @system @nogc
void free(void* user_ptr, string caller = __FUNCTION__)
{
	if (!user_ptr)
		return;

	debug
	{
		import betterc.stdio : FILE, fopen, fprintf, fclose;

		void* base_ptr = cast(void*)(cast(size_t*) user_ptr - 1);
		size_t size = *(cast(size_t*) base_ptr);

		total_heap_usage -= size;

		FILE* log_file = fopen("allocations_log.txt", "a");
		if (log_file)
		{
			fprintf(log_file, "FREE  | Caller: %.*s | Addr: %p | Size: %zu bytes | Total Heap: %zu bytes\n",
				cast(int) caller.length, caller.ptr, user_ptr, size, total_heap_usage);
			fclose(log_file);
		}

		c_free(base_ptr);
	}
	else
		c_free(user_ptr);
}
//endregion
