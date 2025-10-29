#!/bin/bash
# Get detailed audio information for tooltip

# Get volume and mute status
if command -v pamixer >/dev/null 2>&1; then
    volume=$(pamixer --get-volume 2>/dev/null || echo "50")
    muted=$(pamixer --get-mute 2>/dev/null || echo "false")
    
    # Get device info
    device=$(pamixer --list-sinks 2>/dev/null | grep '\*' | awk -F'"' '{print $4}' | head -1 || echo "Default Audio Device")
    
elif command -v amixer >/dev/null 2>&1; then
    # Using amixer
    volume=$(amixer get Master | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50")
    muted=$(amixer get Master | grep -o '\[off\]' >/dev/null && echo "true" || echo "false")
    device="Master"
    
elif command -v pactl >/dev/null 2>&1; then
    # Using pactl
    sink_info=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null)
    volume=$(echo "$sink_info" | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50")
    mute_info=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null)
    muted=$(echo "$mute_info" | grep -q "yes" && echo "true" || echo "false")
    device=$(pactl list short sinks 2>/dev/null | grep "$(pactl get-default-sink 2>/dev/null)" | awk '{print $2}' | sed 's/.*\.\([^.]*\)$/\1/' || echo "Default Audio Device")
    
else
    # Fallback
    volume="50"
    muted="false"
    device="Unknown"
fi

# Format the tooltip
if [ "$muted" = "true" ]; then
    status="Muted"
else
    status="Playing"
fi

echo "Volume: ${volume}%
Status: ${status}
Device: ${device}
Scroll to adjust ±1%"