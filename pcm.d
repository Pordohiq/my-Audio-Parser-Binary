module pcm;

enum PCM_TYPE
{
	INVALID,

	// 16
	S16_LE,
	S16_BE,

	U16_LE,
	U16_BE
}

struct PCM_DATA
{
	PCM_TYPE type;
	uint channels;
	ubyte[] data;
}
