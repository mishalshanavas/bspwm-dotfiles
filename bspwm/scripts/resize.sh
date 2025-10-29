#!/bin/bash

# Dynamic window resizing script for bspwm
# Works with both tiled and floating windows
# Usage: resize.sh [left|right|up|down]

RESIZE_STEP=40

# Check if window is floating
is_floating() {
    bspc query -T -n focused | grep -q '"state":"floating"'
}

case "$1" in
    left)
        if is_floating; then
            # For floating: resize from right edge (shrink width)
            bspc node -z right -$RESIZE_STEP 0
        else
            # For tiled: try both edges
            bspc node -z right -$RESIZE_STEP 0 || bspc node -z left -$RESIZE_STEP 0
        fi
        ;;
    right)
        if is_floating; then
            # For floating: resize from right edge (expand width)
            bspc node -z right $RESIZE_STEP 0
        else
            # For tiled: try both edges
            bspc node -z right $RESIZE_STEP 0 || bspc node -z left $RESIZE_STEP 0
        fi
        ;;
    up)
        if is_floating; then
            # For floating: resize from bottom edge (shrink height)
            bspc node -z bottom 0 -$RESIZE_STEP
        else
            # For tiled: try both edges
            bspc node -z bottom 0 -$RESIZE_STEP || bspc node -z top 0 -$RESIZE_STEP
        fi
        ;;
    down)
        if is_floating; then
            # For floating: resize from bottom edge (expand height)
            bspc node -z bottom 0 $RESIZE_STEP
        else
            # For tiled: try both edges
            bspc node -z bottom 0 $RESIZE_STEP || bspc node -z top 0 $RESIZE_STEP
        fi
        ;;
    *)
        echo "Usage: $0 [left|right|up|down]"
        exit 1
        ;;
esac