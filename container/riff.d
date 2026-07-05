module container.riff;

import stdio;
import convert;

const ubyte[4] RIFF_HEADER = ['R', 'I', 'F', 'F'];

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

ulong get_block_pointer(ubyte[4] block_name, FILE *file)
{
    if (!file)
        return 0;

    ubyte[4] fsize_buffer;

    ulong bytes_read = read_buffer(file, fsize_buffer.ptr, 4, 5);
    if (bytes_read != 4)
        return 0;

    ulong max_pointer_position = fsize_buffer.asUint() + 4;

    print(max_pointer_position.toString);

    return 0;
}
