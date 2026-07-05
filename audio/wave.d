module audio.wave;

import container.riff;

import audio_data;

const ubyte[4] WAVE_HEADER = ['W', 'A', 'V', 'E'];

bool is_stream_wave(ubyte[] stream)
{
    if (stream.length < 12)
        return false;

    ubyte[4] riff_header = stream[0 .. 4];
    ubyte[4] wave_header = stream[8 .. 12];

    return (riff_header == RIFF_HEADER) && (wave_header == WAVE_HEADER);
}

void read_stream_specs_wave(ubyte[] stream)
{
}
