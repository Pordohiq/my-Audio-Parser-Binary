module container.flac;

import betterc.stdint;
import betterc.stdio;
import betterc.convert : asUint;

const ubyte FLAC_BLOCK_HEADER_SIZE = 4;

enum ContainerType : ubyte
{
	STREAMINFO = 0,
	PADDING = 1,
	APPLICATION = 2,
	SEEK_TABLE = 3,
	VORBIS_COMMENT = 4,
	CUESHEET = 5,
	PICTURE = 6,

	FORBIDDEN = 127,

	init = FORBIDDEN
}

private pure nothrow
bool is_last_block(uint block_header)
{
	return block_header % 2 != 0;
}

private pure nothrow
ContainerType get_block_type(const uint block_header)
{
	uint type_value = block_header.bit_subrange(24, 30);

	switch (type_value)
	{
	case ContainerType.STREAMINFO:
	case ContainerType.PADDING:
	case ContainerType.APPLICATION:
	case ContainerType.SEEK_TABLE:
	case ContainerType.VORBIS_COMMENT:
	case ContainerType.CUESHEET:
	case ContainerType.PICTURE:
		return cast(ContainerType) type_value;

	default:
		return ContainerType.init;
	}
}

private pure nothrow
ulong get_block_length(const uint block_header)
{
	return block_header.bit_subrange(0, 23);
}

ulong get_block_pointer(FILE* file, ContainerType block_name, ulong starting_pointer = 4)
{
	if (!file)
		return 0;

	ubyte[4] block_header_buffer;

	ulong bytes_read = read_buffer(file, block_header_buffer.ptr, 4, starting_pointer);
	if (bytes_read != 4)
		return 0;

	uint block_header = block_header_buffer.asUint(false);

	ulong pointer_position = starting_pointer;

	while (true)
	{
		bytes_read = read_buffer(file, block_header_buffer.ptr, 4, pointer_position);
		if (bytes_read != 4)
			return 0;

		block_header = block_header_buffer.asUint(false);

		ContainerType ct = get_block_type(block_header);
		ulong block_length = get_block_length(block_header);

		//IF FOUND
		if (block_name == ct)
			return pointer_position;

		pointer_position += block_length + FLAC_BLOCK_HEADER_SIZE;

		if (is_last_block(block_header))
			break;
	}

	return 0;
}
