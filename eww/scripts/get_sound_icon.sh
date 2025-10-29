#!/bin/bash
# Get sound icon based on volume level and mute state

# Get volume and mute status
if command -v pamixer >/dev/null 2>&1; then
    volume=$(pamixer --get-volume 2>/dev/null || echo "50")
    muted=$(pamixer --get-mute 2>/dev/null || echo "false")
elif command -v amixer >/dev/null 2>&1; then
    # Using amixer
    volume=$(amixer get Master | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50")
    muted=$(amixer get Master | grep -o '\[off\]' >/dev/null && echo "true" || echo "false")
elif command -v pactl >/dev/null 2>&1; then
    # Using pactl
    sink_info=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null)
    volume=$(echo "$sink_info" | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50")
    mute_info=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null)
    muted=$(echo "$mute_info" | grep -q "yes" && echo "true" || echo "false")
else
    # Fallback
    volume="50"
    muted="false"
fi

# Choose icon based on mute status and volume level
if [ "$muted" = "true" ] || [ "$volume" = "0" ]; then
    echo "󰖁"  # Muted/No sound
elif [ "$volume" -ge 70 ]; then
    echo "󰕾"  # High volume
elif [ "$volume" -ge 30 ]; then
    echo "󰖀"  # Medium volume
else
    echo "󰕿"  # Low volume
fi