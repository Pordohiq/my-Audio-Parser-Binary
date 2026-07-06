module app;

import betterc.convert;
import betterc.stdio;

import audio.wave;
import audio.flac;

import container.riff;

extern (C) int main(int argc, char** argv)
{
	string[] args = parse_arguments(argc, argv);

	print("This is a very empty project till now...");
	print(args);

	if (args.length > 1)
	{
		FILE* file = open_file("./tests/wave_48k_s16le_2.wav", FileMode.READ_BYTES);
		print(is_file_riff(file));
		print(get_block_pointer("fmt ".asBytes[0 .. 4], file).toString);
		read_file_specs_wave(file);
		close_file(file);
	}

	return 0;
}
