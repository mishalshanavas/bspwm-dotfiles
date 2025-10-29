#!/bin/bash

# Advanced window resizing script for bspwm
# Usage: resize_advanced.sh [left|right|up|down] [optional_step]

# Default resize step (pixels)
DEFAULT_STEP=40
STEP=${2:-$DEFAULT_STEP}

# Get current window info
current_window=$(bspc query -N -n focused)
if [ -z "$current_window" ]; then
    exit 1
fi

# Function to resize window intelligently
resize_window() {
    local direction=$1
    local pixels=$2
    
    case "$direction" in
        left)
            # Try expanding left edge first, then contracting right edge
            bspc node -z left -$pixels 0 || bspc node -z right -$pixels 0
            ;;
        right)
            # Try expanding right edge first, then contracting left edge
            bspc node -z right $pixels 0 || bspc node -z left $pixels 0
            ;;
        up)
            # Try expanding up first, then contracting bottom
            bspc node -z top 0 -$pixels || bspc node -z bottom 0 -$pixels
            ;;
        down)
            # Try expanding down first, then contracting top
            bspc node -z bottom 0 $pixels || bspc node -z top 0 $pixels
            ;;
    esac
}

# Main execution
case "$1" in
    left|right|up|down)
        resize_window "$1" "$STEP"
        ;;
    reset)
        # Reset window to balanced state
        bspc node @/ -B
        ;;
    *)
        echo "Usage: $0 [left|right|up|down|reset] [optional_step_size]"
        echo "Default step size: $DEFAULT_STEP pixels"
        exit 1
        ;;
esac