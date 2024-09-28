package main

import "windows_fixer_exe/cli"
import "windows_fixer_exe/reg"
import "windows_fixer_exe/tui"

import "core:os"

main :: proc() {
	args := os.args

	if len(args) > 1 {
		cli.init(&args)
		return
	}

	tui.init()
	reg.get_value("")
}
