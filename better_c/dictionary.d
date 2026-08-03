module betterc.dictionary;

import betterc.stdlib;

private
struct Pair(K, V)
{
	K key;
	V value;

	string toString() const
	{
		return "";
	}
}

struct Dictionary(K, V)
{
	private Pair!(K, V)[] values;

	void set_value(K key, V value)
	{
		if (contains_key(key))
		{
			ulong key_index = get_key_index(key);
			values[key_index].value = value;
		}
		else
		{
			values.resize_array!(Pair!(K, V))(values.length + 1);
			values[cast(ulong) values.length - 1] = Pair!(K, V)(key, value);
		}
	}

	bool contains_key(K key)
	{
		for (ulong i = 0; i < values.length; i++)
		{
			Pair!(K, V) current_value = values[i];
			if (current_value.key == key)
			{
				return true;
			}
		}
		return false;
	}

	private
	ulong get_key_index(K key)
	{
		for (ulong i = 0; i < values.length; i++)
		{
			Pair!(K, V) current_value = values[i];
			if (current_value.key == key)
			{
				return i;
			}
		}
		return 0;
	}

	string toString() const
	{
		return "";
	}
}
