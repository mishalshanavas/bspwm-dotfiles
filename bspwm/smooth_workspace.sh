#!/bin/bash

# Smooth workspace switching script for bspwm with animations
# Usage: ./smooth_workspace.sh [next|prev|1-10]

case "$1" in
    "next")
        # Get current desktop
        current=$(bspc query -D -d focused --names)
        # Switch to next with smooth transition
        bspc desktop -f next
        ;;
    "prev")
        # Get current desktop
        current=$(bspc query -D -d focused --names)
        # Switch to previous with smooth transition
        bspc desktop -f prev
        ;;
    [1-9]|10)
        # Switch to specific desktop
        bspc desktop -f "^$1"
        ;;
    *)
        echo "Usage: $0 [next|prev|1-10]"
        exit 1
        ;;
esac

# Optional: Brief pause for animation to complete
sleep 0.1