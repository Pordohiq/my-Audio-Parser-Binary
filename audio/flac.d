module audio.flac;

const ubyte[4] FLAC_HEADER = ['f', 'L', 'a', 'C'];

bool is_stream_flac(ubyte[] stream)
{
    if (stream.length < 4)
        return false;

    ubyte[4] flac_header = stream[0  .. 4];

    return flac_header == FLAC_HEADER;
}
