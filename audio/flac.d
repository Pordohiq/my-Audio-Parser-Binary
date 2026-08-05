module audio.flac;

import audio_data;

import container.flac;

import betterc.algorithm : toLowercase;
import betterc.stdio;
import betterc.stdlib;
import betterc.convert;
import betterc.cstring;

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

AudioMetaData read_metadata_flac(FILE* file)
{
	if (!file)
		return AudioMetaData();

	if (!file.is_file_flac)
		return AudioMetaData();

	ulong vorbis_comment_block_position = file.get_block_pointer(ContainerType.VORBIS_COMMENT);

	ubyte[] vorbis_comment_block = read_block_body(file, vorbis_comment_block_position);

	AudioMetaData amd = AudioMetaData();

	ulong pointer = 0;

	uint vendor_string_length = vorbis_comment_block[0 .. 4].asUint(ENDIAN.LITTLE);
	pointer += 4;
	ubyte[] vendor_string = copy_array!ubyte(vorbis_comment_block, pointer, pointer + vendor_string_length);
	pointer += vendor_string_length;

	if (vendor_string.length != vendor_string_length)
		return AudioMetaData();

	amd.other_values.set_value(Cstring("Vendor String"), Cstring(vendor_string));

	uint num_data_fields = (vorbis_comment_block[pointer .. pointer + 4])[0 .. 4]
		.asUint(ENDIAN.LITTLE);
	pointer += 4;

	// Verify for pointer overflow. ISSUE 2.
	for (uint i = 0; i < num_data_fields; i++)
	{
		uint field_length = (vorbis_comment_block[pointer .. pointer + 4])[0 .. 4]
			.asUint(ENDIAN.LITTLE);
		pointer += 4;

		ubyte[] field = vorbis_comment_block[pointer .. pointer + field_length];
		pointer += field_length;

		if (field.length != field_length)
			continue;

		Cstring[] key_value = Cstring(field).splitByFirst('=');
		if (key_value.length != 2)
		{
			continue;
		}

		Cstring key = key_value[0];
		Cstring value = key_value[1];

		key.toLowercase;

		if (key == Cstring("title"))
			amd.title = value;

		else if (key == Cstring("artist"))
			amd.artist = value;

		else if (key == Cstring("album"))
			amd.album = value;

		else if (key == Cstring("tracknumber") || key == Cstring("track"))
			amd.track_number = value;

		else if (key == Cstring("date"))
			amd.date = value;

		else if (key == Cstring("genre"))
			amd.genre = value;

		else
			amd.other_values.set_value(key, value);
	}

	return amd;
}
