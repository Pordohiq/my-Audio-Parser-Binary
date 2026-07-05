module app;

import convert;
import stdio;

import audio.wave;
import audio.flac;

import container.riff;

extern (C) int main(int argc, char** argv)
{
	string[] args = parse_arguments(argc, argv);

	print("This is a very empty project till now...");
	print(args);

	ubyte[] file_content = read_file_bytes("./tests/wave_48k_s16_2.wav");

	ubyte[100] head = file_content[0 .. 100];

	print(head.is_stream_wave);

	if (args.length > 1)
	{
		FILE* file = open_file("./tests/wave_48k_s16_2.wav", FileMode.READ_BYTES);
		print(is_file_riff(file));
	}

	return 0;
}
