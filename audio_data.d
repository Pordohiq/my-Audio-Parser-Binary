module audio_data;

struct Audio
{
    ubyte channels;
    ubyte[] interleaved_audio; // Maybe L_Channel / R_Channel would be better.
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
