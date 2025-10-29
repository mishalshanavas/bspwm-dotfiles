#!/bin/bash
# Change volume by specified amount

change=$1

if [ -z "$change" ]; then
    echo "Usage: $0 [+5|-5]"
    exit 1
fi

# Change volume using available tools
if command -v pamixer >/dev/null 2>&1; then
    pamixer --increase "$change" 2>/dev/null || pamixer --decrease "${change#-}" 2>/dev/null
elif command -v amixer >/dev/null 2>&1; then
    if [[ "$change" == +* ]]; then
        amixer set Master "${change##+}%+" >/dev/null 2>&1
    else
        amixer set Master "${change#-}%-" >/dev/null 2>&1
    fi
elif command -v pactl >/dev/null 2>&1; then
    if [[ "$change" == +* ]]; then
        pactl set-sink-volume @DEFAULT_SINK@ "+${change##+}%" 2>/dev/null
    else
        pactl set-sink-volume @DEFAULT_SINK@ "-${change#-}%" 2>/dev/null
    fi
fi

# Update eww polls to reflect changes immediately
eww update volume_poll="$(~/.config/eww/scripts/get_volume.sh)" 2>/dev/null
eww update sound_icon_poll="$(~/.config/eww/scripts/get_sound_icon.sh)" 2>/dev/null
eww update audio_tooltip="$(~/.config/eww/scripts/get_audio_tooltip.sh)" 2>/dev/null