module audio.wave;

import container.riff;

import betterc.stdio;
import betterc.stdlib;
import betterc.convert;
import betterc.algorithm;

import audio_data;

const ubyte[4] WAVE_HEADER = ['W', 'A', 'V', 'E'];

bool is_stream_wave(ubyte[] stream)
{
	if (stream.length < 12)
		return false;

	ubyte[4] wave_header = stream[8 .. 12];

	return stream.is_stream_riff && (wave_header == WAVE_HEADER);
}

bool is_file_wave(FILE* file)
{
	if (file == null)
		return false;

	ubyte[12] header;

	ulong bytes_read = read_buffer(file, header.ptr, 12, 0);

	if (bytes_read != 12)
		return false;

	return is_stream_wave(header);
}

struct WaveSpecs
{
	ushort encoding;
	ushort channels;
	uint sample_rate;
	uint byte_rate;
	ushort block_align;
	ushort bit_depth;
}

WaveSpecs read_file_specs_wave(FILE* file)
{
	if (!file)
		return WaveSpecs();

	if (!file.is_file_wave)
		return WaveSpecs();

	ulong fmt_chunk_position = get_block_pointer("fmt ".asBytes[0 .. 4], file);

	ubyte[] fmt_chunk = read_block_body(file, fmt_chunk_position);

	if (fmt_chunk.length > 16)
		print(
			"WARNING: There is more data in the 'fmt ' than we know of. Unknown parts of the data will be ignored.");

	WaveSpecs spec = WaveSpecs();

	spec.encoding = fmt_chunk[0 .. 2].asUshort;
	spec.channels = fmt_chunk[2 .. 4].asUshort;
	spec.sample_rate = fmt_chunk[4 .. 8].asUint;
	spec.byte_rate = fmt_chunk[8 .. 12].asUint;
	spec.block_align = fmt_chunk[12 .. 14].asUshort;
	spec.bit_depth = fmt_chunk[14 .. 16].asUshort;

	if (spec.block_align != (spec.channels * spec.bit_depth) / 8)
		print("WARNING: file may be corrupted. 'block_align' doesn't match.");

	if (spec.byte_rate != spec.sample_rate * spec.block_align)
		print("WARNING: file may be corrupted. 'byte_rate' doesn't match.");

	free(fmt_chunk.ptr);

	return spec;
}

AudioMetaData read_metadata_wave(FILE* file)
{
	if (!file)
		return AudioMetaData();

	if (!file.is_file_wave)
		return AudioMetaData();

	ulong list_chunk_position = get_block_pointer("LIST".asBytes[0 .. 4], file);

	ubyte[] list_chunk = read_block_body(file, list_chunk_position);

	bool is_valid = (list_chunk.length >= 4) && list_chunk.startsWith("INFO".asBytes);

	while (!is_valid)
	{
		list_chunk_position += RIFF_SUBCHUNK_HEADER_SIZE + list_chunk.length +  // Length of this chunck with header
			(
				(list_chunk.length % 2 == 0) ? 0 : 1); // Account for the padding byte.

		list_chunk_position = get_block_pointer("LIST".asBytes[0 .. 4], file, list_chunk_position);

		if (list_chunk_position == 0)
			return AudioMetaData();

		list_chunk = read_block_body(file, list_chunk_position);

		is_valid = (list_chunk.length > 4) && list_chunk.startsWith("INFO".asBytes);
	}

	AudioMetaData amd = AudioMetaData();

	ulong pointer = 4;
	while (pointer < list_chunk.length)
	{
		ubyte[4] value_name = list_chunk[pointer .. pointer + 4];
		uint value_length = (list_chunk[pointer + 4 .. pointer + 8])[0 .. 4].asUint;
		pointer += 8;

		ubyte[] value = copy_array!ubyte(list_chunk, pointer, pointer + value_length);
		if (value.length == 0)
		{
			return AudioMetaData();
		}

		pointer += value_length;

		print(cast(string) value);

	}

	return AudioMetaData();
}
