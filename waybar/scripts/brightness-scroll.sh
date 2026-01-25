#!/bin/bash

# Brightness scroll control with minimum limit
MIN=10

get_brightness() {
    brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'
}

case "$1" in
    up)
        swayosd-client --brightness raise
        ;;
    down)
        CURRENT=$(get_brightness)
        if [[ $CURRENT -gt $MIN ]]; then
            swayosd-client --brightness lower
            # Check if it went below minimum and correct
            NEW=$(get_brightness)
            if [[ $NEW -lt $MIN ]]; then
                brightnessctl set ${MIN}% >/dev/null
            fi
        fi
        ;;
esac

pkill -RTMIN+8 waybar
