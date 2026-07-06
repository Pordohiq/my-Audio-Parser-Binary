module betterc.stdlib;

public import core.stdc.stdlib;

T[] allocate_array(T)(ulong length) @nogc
{
	T* ptr = cast(T*) malloc(T.sizeof * length);

	if (!ptr)
		return null;

	return ptr[0 .. length];
}
