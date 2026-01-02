#!/usr/bin/env bash
mkdir -p ~/.config/yabai/layouts
yabai -m query --windows > ~/.config/yabai/layouts/layout_$(date +%H%M%S).json
echo "✅ Layout saved!"
