module app;

import betterc.convert;
import betterc.stdio;

import audio.wave;
import audio.flac;

import container.riff;

extern (C)
int main(int argc, char** argv)
{
	string[] args = parse_arguments(argc, argv);

	print("This is a very empty project till now...");
	print(args);

	debug
	{
		FILE* log_file = fopen("allocations_log.txt", "w");
		if (log_file)
			fclose(log_file);
	}

	if (args.length > 1)
	{
		FILE* file = open_file(args[1], FileMode.READ_BYTES);
		read_file_specs_wave(file);
		read_metadata_wave(file);
		close_file(file);
	}

	return 0;
}
