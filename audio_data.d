module audio_data;

import pcm;

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
}
