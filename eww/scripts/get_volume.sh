#!/bin/bash
# Get volume level
if command -v pamixer >/dev/null 2>&1; then
    pamixer --get-volume 2>/dev/null || echo "50"
elif command -v amixer >/dev/null 2>&1; then
    amixer get Master | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50"
elif command -v pactl >/dev/null 2>&1; then
    pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50"
else
    echo "50"
fi