module audio.flac;

import betterc.stdio;

const ubyte[4] FLAC_HEADER = ['f', 'L', 'a', 'C'];

bool is_stream_flac(ubyte[] stream)
{
    if (stream.length < 4)
        return false;

    ubyte[4] flac_header = stream[0 .. 4];

    return flac_header == FLAC_HEADER;
}

bool is_file_flac(FILE* file)
{
    if (file == null)
        return false;

    ubyte[4] header;

    ulong bytes_read = read_buffer(file, header.ptr, 4, 0);

    if (bytes_read != 4)
        return false;

    return is_stream_flac(header);
}
