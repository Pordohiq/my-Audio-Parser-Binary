module app;

import betterc.convert;
import betterc.stdio;

import audio.wave;
import audio.flac;

import container.riff;
import container.flac;

extern (C)
int main(int argc, char** argv)
{
	string[] args = parse_arguments(argc, argv);

	print("This is a very empty project till now...");
	print(args);

	if (args.length > 1)
	{
		FILE* file = open_file(args[1], FileMode.READ_BYTES);
		if (file.is_file_flac)
		{
			ulong pointer = file.get_block_pointer(ContainerType.PICTURE);
			print(pointer.toString);
		}
		else if (file.is_file_wave)
			read_metadata_wave(file);

		close_file(file);
	}

	return 0;
}
