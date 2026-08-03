module audio.wave;

import container.riff;

import betterc.stdio;
import betterc.stdlib;
import betterc.convert;
import betterc.algorithm;
import betterc.dictionary;
import betterc.cstring : Cstring;

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

	ulong fmt_chunk_position = file.get_block_pointer("fmt ".asBytes[0 .. 4]);

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

	//TODO: Verify that the different attributes match; ISSUE 1.

	free(fmt_chunk.ptr);

	return spec;
}

AudioMetaData read_metadata_wave(FILE* file)
{
	if (!file)
		return AudioMetaData();

	if (!file.is_file_wave)
		return AudioMetaData();

	ulong list_chunk_position = file.get_block_pointer("LIST".asBytes[0 .. 4]);

	ubyte[] list_chunk = read_block_body(file, list_chunk_position);

	bool is_valid = (list_chunk.length >= 4) && list_chunk.startsWith("INFO".asBytes);

	while (!is_valid)
	{
		list_chunk_position += RIFF_SUBCHUNK_HEADER_SIZE + list_chunk.length +  // Length of this chunck with header
			(
				(list_chunk.length % 2 == 0) ? 0 : 1); // Account for the padding byte.

		list_chunk_position = file.get_block_pointer("LIST".asBytes[0 .. 4], list_chunk_position);

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
			continue;
		}

		//Known fields.
		if (value_name == "INAM".asBytes)
			amd.title = Cstring(value);

		else if (value_name == "IART".asBytes)
			amd.artist = Cstring(value);

		else if (value_name == "ICRD".asBytes)
			amd.date = Cstring(value);

		else if (value_name == "IPRD".asBytes || value_name == "ILBC")
			amd.album = Cstring(value);

		else if (value_name == "IGNR".asBytes)
			amd.genre = Cstring(value);

		else if (value_name == "ITRK".asBytes)
			amd.track_number = Cstring(value);

		else
		{
			ubyte[] name_array = duplicate_array(value_name);
			amd.other_values.set_value(Cstring(name_array), Cstring(value));
		}

		pointer += value_length + ((value_length % 2 == 0) ? 0 : 1);
	}

	return amd;
}
