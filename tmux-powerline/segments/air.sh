#!/usr/bin/env bash

run_segment() {
	if [ -z "$TMUX_POWERLINE_SEG_AIR_LAT" ] && [ -z "$TMUX_POWERLINE_SEG_AIR_LON" ]; then
		return 0
	fi

	if [ -z "$TMUX_POWERLINE_SEG_AIR_OPEN_WEATHER_API_KEY" ]; then
		return 0
	fi

	# shellcheck source=/dev/null
	source "${TMUX_POWERLINE_DIR_SEGMENTS}/air.sh"
	run_segment
}
