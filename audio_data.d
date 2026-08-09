module audio_data;

import pcm;

import betterc.dictionary;

struct Audio
{
	PCM_DATA audio;
	AudioMetaData* metadata;
}

struct AudioMetaData
{
	string artist;
	string title;
	string album;
	string number;
	string year;
	string genre;

	Dictionary!(string, string) other_values;
}
