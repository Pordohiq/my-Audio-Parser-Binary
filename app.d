module app;

import convert;
import stdio;

extern (C) int main(int argc, char** argv)
{

	string[] args = parse_arguments(argc, argv);

	print("This is a very empty project till now...");
	print(args);

	return 0;
}
