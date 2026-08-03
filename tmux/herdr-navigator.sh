#!/bin/sh
set -eu

herdr_direction="$1"
tmux_direction="$2"
key="${3:-}"
pane_tty="$(tmux display-message -p '#{pane_tty}')"

is_herdr() {
  ps -o comm= -t "$pane_tty" | grep -iqE '(^|/)herdr$'
}

is_vim() {
  ps -o state= -o comm= -t "$pane_tty" |
    grep -iqE '^[^TXZ ]+ +(\S+/)?g?(view|l?n?vim?x?)(diff)?$'
}

herdr_session() {
  ps -o args= -t "$pane_tty" |
    sed -n 's/.*herdr --session \([^ ]*\).*/\1/p' |
    head -n 1
}

run_herdr() {
  session="$(herdr_session)"
  if [ -n "$session" ]; then
    herdr --session "$session" "$@"
  else
    herdr "$@"
  fi
}

if [ -n "$key" ] && is_vim; then
  tmux send-keys "$key"
  exit 0
fi

if is_herdr; then
  if run_herdr pane neighbor --current --direction "$herdr_direction" 2>/dev/null | grep -q '"neighbor_pane_id"'; then
    run_herdr pane focus --current --direction "$herdr_direction" >/dev/null 2>&1
  else
    tmux select-pane -"$tmux_direction"
  fi
else
  tmux select-pane -"$tmux_direction"
fi
