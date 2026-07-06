module container.riff;

import stdio;
import convert;

const ubyte[4] RIFF_HEADER = ['R', 'I', 'F', 'F'];

const ubyte RIFF_SUBCHUNK_HEADER_SIZE = 8;

bool is_stream_riff(ubyte[] stream)
{
    if (stream.length < 4)
        return false;

    ubyte[4] riff_header = stream[0 .. 4];

    return riff_header == RIFF_HEADER;
}

bool is_file_riff(FILE *file)
{
    if (file == null)
        return false;

    ubyte[4] header;

    ulong bytes_read = read_buffer(file, header.ptr, 4, 0);

    if (bytes_read != 4)
        return false;

    print(header.toString);

    return is_stream_riff(header);
}

/// Gets the offset of given chunk from the beginning of the file.
/// It gives back the offset of the HEADER and not the BODY!
/// If any error occurs, it returns 0!
ulong get_block_pointer(ubyte[4] block_name, FILE *file)
{
    if (!file)
        return 0;

    ubyte[4] fsize_buffer;

    ulong bytes_read = read_buffer(file, fsize_buffer.ptr, 4, 5);
    if (bytes_read != 4)
        return 0;

    ulong max_pointer_position = fsize_buffer.asUint() + 4;

    ulong pointer_position = 12;

    while (max_pointer_position > pointer_position)
    {
        ubyte[8] subchunk_header;

        bytes_read = read_buffer(file, subchunk_header.ptr, RIFF_SUBCHUNK_HEADER_SIZE, pointer_position);

        if (bytes_read != RIFF_SUBCHUNK_HEADER_SIZE)
            return 0;

        ubyte[4] subchunk_header_name = subchunk_header[0 .. 4];
        ubyte[4] subchunk_header_size = subchunk_header[4 .. 8];

        if (block_name == subchunk_header_name)
            return pointer_position;

        pointer_position += (subchunk_header_size.asUint) + RIFF_SUBCHUNK_HEADER_SIZE;
    }

    return 0;
}
