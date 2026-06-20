#!/usr/bin/env bash

run_segment() {
	if [ -z "$TMUX_POWERLINE_SEG_WEATHER_LAT" ] && [ -z "$TMUX_POWERLINE_SEG_WEATHER_LON" ]; then
		return 0
	fi

	# shellcheck source=/dev/null
	source "${TMUX_POWERLINE_DIR_SEGMENTS}/weather.sh"
	run_segment
}
