#!/usr/bin/env bash

run_segment() {
	local zoomed
	zoomed=$(tmux display-message -p -F '#{window_zoomed_flag}')

	if [ "$zoomed" = "1" ]; then
		echo "ZOOM"
	fi
}
