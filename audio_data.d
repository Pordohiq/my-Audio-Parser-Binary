module audio_data;

import pcm;

import betterc.cstring;
import betterc.dictionary;
import betterc.stdio : print;

struct Audio
{
	PCM_DATA audio;
	AudioMetaData* metadata;
}

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
