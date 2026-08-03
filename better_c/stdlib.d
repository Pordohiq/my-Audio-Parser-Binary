module betterc.stdlib;

public import core.stdc.stdlib;
import core.stdc.string : memcpy;

/// Allocates a dynamic array on the heap
nothrow @system @nogc
T[] allocate_array(T)(ulong length)
{
	T* ptr = cast(T*) malloc(T.sizeof * length);

	if (!ptr)
		return [];

	return ptr[0 .. length];
}

nothrow
void resize_array(T)(ref T[] array, ulong new_size)
{
	T[] new_array = allocate_array!T(new_size);
	for (ulong i = 0; i < array.length; i++)
	{
		new_array[i] = array[i];
	}

	array = new_array;
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
