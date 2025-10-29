#!/bin/bash

# Dynamic window resizing script for bspwm
# Usage: resize.sh [left|right|up|down]

# Resize increment (pixels)
RESIZE_STEP=40

case "$1" in
    left)
        # Try to resize from the right edge first, then left edge
        bspc node -z right -$RESIZE_STEP 0 || bspc node -z left -$RESIZE_STEP 0
        ;;
    right)
        # Try to resize from the right edge first, then left edge  
        bspc node -z right $RESIZE_STEP 0 || bspc node -z left $RESIZE_STEP 0
        ;;
    up)
        # Try to resize from the bottom edge first, then top edge
        bspc node -z bottom 0 -$RESIZE_STEP || bspc node -z top 0 -$RESIZE_STEP
        ;;
    down)
        # Try to resize from the bottom edge first, then top edge
        bspc node -z bottom 0 $RESIZE_STEP || bspc node -z top 0 $RESIZE_STEP
        ;;
    *)
        echo "Usage: $0 [left|right|up|down]"
        exit 1
        ;;
esac