module audio_data;

import pcm;

import betterc.cstring;
import betterc.dictionary;
import betterc.stdio : print;

extern (C)
struct Audio
{
	PCM_DATA audio;
	AudioMetaData* metadata;
}

extern (C)
struct AudioMetaData
{
	Cstring title;
	Cstring artist;
	Cstring album;
	Cstring track_number;
	Cstring date;
	Cstring genre;

	Dictionary!(Cstring, Cstring) other_values;

	string toString() const
	{

		return "";
	}
}
