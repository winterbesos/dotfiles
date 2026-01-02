#!/usr/bin/env bash
layout_file="$1"
if [ ! -f "$layout_file" ]; then
  echo "❌ layout file not found"
  exit 1
fi

jq -c '.[]' "$layout_file" | while read -r win; do
  id=$(echo "$win" | jq '.id')
  x=$(echo "$win" | jq '.frame.x')
  y=$(echo "$win" | jq '.frame.y')
  w=$(echo "$win" | jq '.frame.w')
  h=$(echo "$win" | jq '.frame.h')
  yabai -m window "$id" --move abs:$x:$y
  yabai -m window "$id" --resize abs:$w:$h
done
