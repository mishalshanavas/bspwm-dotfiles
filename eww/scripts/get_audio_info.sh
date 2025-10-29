#!/bin/bash
# Combined audio info script - outputs volume, icon, and tooltip in one call
# Usage: get_audio_info.sh [volume|icon|tooltip]

get_audio_data() {
    if command -v pamixer >/dev/null 2>&1; then
        volume=$(pamixer --get-volume 2>/dev/null || echo "50")
        muted=$(pamixer --get-mute 2>/dev/null || echo "false")
        device=$(pamixer --list-sinks 2>/dev/null | grep '\*' | awk -F'"' '{print $4}' | head -1 || echo "Default Audio Device")
    elif command -v amixer >/dev/null 2>&1; then
        volume=$(amixer get Master | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50")
        muted=$(amixer get Master | grep -o '\[off\]' >/dev/null && echo "true" || echo "false")
        device="Master"
    elif command -v pactl >/dev/null 2>&1; then
        sink_info=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null)
        volume=$(echo "$sink_info" | grep -o '[0-9]*%' | head -1 | tr -d '%' || echo "50")
        mute_info=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null)
        muted=$(echo "$mute_info" | grep -q "yes" && echo "true" || echo "false")
        device="Default Audio Device"
    else
        volume="50"; muted="false"; device="Unknown"
    fi
}

case "$1" in
    "volume")
        get_audio_data
        echo "$volume"
        ;;
    "icon")
        get_audio_data
        if [ "$muted" = "true" ] || [ "$volume" = "0" ]; then
            echo "󰖁"  # Muted
        elif [ "$volume" -ge 70 ]; then
            echo "󰕾"  # High volume
        elif [ "$volume" -ge 30 ]; then
            echo "󰖀"  # Medium volume
        else
            echo "󰕿"  # Low volume
        fi
        ;;
    "tooltip")
        get_audio_data
        status="Playing"
        [ "$muted" = "true" ] && status="Muted"
        echo "Volume: ${volume}%
Status: ${status}
Device: ${device}
Scroll to adjust ±1%"
        ;;
    *)
        echo "Usage: $0 [volume|icon|tooltip]"
        ;;
esac