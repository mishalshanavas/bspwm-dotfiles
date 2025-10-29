#!/bin/bash

# Mouse control script for bspwm
# Usage: mouse_control.sh [move|resize]

case "$1" in
    "move")
        # Enable window moving with mouse
        eval $(xdotool getmouselocation --shell)
        bspc node -v $X $Y
        ;;
    "resize")
        # Enable window resizing with mouse
        eval $(xdotool getmouselocation --shell)
        # Get window size and position
        WIN_INFO=$(bspc query -T -n focused)
        # Resize from current mouse position
        bspc node -z right $X 0
        bspc node -z bottom 0 $Y
        ;;
    *)
        echo "Usage: $0 [move|resize]"
        exit 1
        ;;
esac