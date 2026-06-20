module app;

import convert;
import stdio;

extern (C) int main(int argc, char** argv)
{

	string[] args = parse_arguments(argc, argv);

	print("This is a very empty project till now...");
	print(args);

	if ("./app.d".file_exists) print("true");

	ubyte[] file_content = read_file_bytes("./app.d");

	print(file_content.toString);

	return 0;
}
