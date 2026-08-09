module betterc.dictionary;

import betterc.stdlib;

private
struct Pair(T, Q)
{
	T key;
	Q value;
}

struct Dictionary(T, Q)
{
	private Pair!(T, Q)[] values;

	this()
	{
		values = null;
		length = 0;
	}

	void set_value(T, Q)(T key, Q value)
	{
		if (contains_key!(T, Q)(key))
		{
			ulong key_index = get_key_index!(T, Q)(key);
			Pair!(T, Q)* current_pair = values[key_index];
			current_pair.value = value;
		}
		else
		{
			values.resize_array!(Pair!(T, Q))(values.length + 1);
			values[cast(ulong) values.length - 1] = Pair!(T, Q)(key, value);
		}
	}

	bool contains_key(T, Q)(T key)
	{
		for (ulong i = 0; i < length; i++)
		{
			Pair!(T, Q) current_value = values[i];
			if (current_value.key == key)
			{
				return true;
			}
		}
		return false;
	}

	private
	ulong get_key_index(T, Q)(T key)
	{
		for (ulong i = 0; i < length; i++)
		{
			Pair!(T, Q) current_value = values[i];
			if (current_value.key == key)
			{
				return i;
			}
		}
		return 0;
	}
}
