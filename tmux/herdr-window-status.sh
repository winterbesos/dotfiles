#!/bin/sh
set -eu

target="${1:-}"
[ -n "$target" ] || exit 0

status_for_herdr_pid() {
  pid="$1"
  command_line="$(ps -o command= -p "$pid" 2>/dev/null || true)"
  session="$(printf '%s\n' "$command_line" | awk '{
    for (i = 1; i <= NF; i++) {
      if ($i == "--session" && (i + 1) <= NF) { print $(i + 1); exit }
      if ($i ~ /^--session=/) { sub(/^--session=/, "", $i); print $i; exit }
    }
  }')"

  if [ -n "$session" ]; then
    herdr --session "$session" api snapshot 2>/dev/null
  else
    herdr api snapshot 2>/dev/null
  fi
}

tmux list-panes -t "$target" -F "#{pane_current_command}\t#{pane_pid}" 2>/dev/null |
while IFS="	" read -r current_command pane_pid; do
  case "$current_command" in
    herdr|*/herdr)
      if status_for_herdr_pid "$pane_pid" | grep -q '"agent_status":"blocked"'; then
        printf '#[fg=black,bg=yellow,bold] ! #[default]'
        exit 0
      fi
      ;;
  esac
done
