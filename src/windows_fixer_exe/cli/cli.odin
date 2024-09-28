package cli

import "../reg"
import "core:fmt"
import "core:os"
// import "core:sys/windows"

println := fmt.println
printf := fmt.printf


@(private)
print_help :: proc(args: ^[]string) -> int {
	printf("Usage: %s [options]\n", args[0])
	println(
		"Options:",
		"  -h, --help        Display this help message.",
		"  -v, --version     Display the version of the program.",
		"  -i, --system-info Display system information.",
		"  -r, --repair      Scan, and Repair the system.",
		"  -s, --setup       Run the setup, the same as the TUI or running the program without any arguments.",
		"  -a, --auto        Automatically patch the system based on recommendations.",
		sep = "\n",
	)
	return 1
}


handle_args :: proc(args: ^[]string) -> int {
	switch args[1] {
	case "-h", "--help":
		return print_help(args)
	case "-v", "--version":
		println("Version: 0.1.0")
	case "-i", "--system-info":
		println("System Information:")
	case "-r", "--repair":
		println("Repairing the system...")
	case "-s", "--setup":
		println("Running the setup...")
	case "-a", "--auto":
		println("Automatically patching the system...")
	}
	return 0
}


init :: proc(args: ^[]string) -> int {
	if len(args) > 1 {
		return print_help(args)
	}
	return 0
}
