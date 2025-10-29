#!/bin/bash

# Bulk window state management for bspwm
# Usage: bulk_window_state.sh [floating|tiled] [workspace_number]

STATE="$1"
WORKSPACE="$2"

if [ -z "$STATE" ]; then
    echo "Usage: $0 [floating|tiled] [workspace_number]"
    echo "If workspace_number is omitted, applies to current workspace"
    exit 1
fi

# If no workspace specified, use current workspace
if [ -z "$WORKSPACE" ]; then
    DESKTOP_ID=$(bspc query -D -d focused)
else
    DESKTOP_ID=$(bspc query -D -d "^$WORKSPACE")
fi

if [ -z "$DESKTOP_ID" ]; then
    echo "Error: Invalid workspace"
    exit 1
fi

# Get all windows in the specified workspace
WINDOWS=$(bspc query -N -d "$DESKTOP_ID")

if [ -z "$WINDOWS" ]; then
    echo "No windows found in workspace"
    exit 0
fi

case "$STATE" in
    "floating")
        echo "Making all windows floating in workspace..."
        for window in $WINDOWS; do
            bspc node "$window" -t floating
        done
        notify-send "BSPWM" "All windows set to floating"
        ;;
    "tiled")
        echo "Making all windows tiled in workspace..."
        for window in $WINDOWS; do
            bspc node "$window" -t tiled
        done
        notify-send "BSPWM" "All windows set to tiled"
        ;;
    *)
        echo "Invalid state: $STATE"
        echo "Use 'floating' or 'tiled'"
        exit 1
        ;;
esac

echo "Applied $STATE state to $(echo "$WINDOWS" | wc -w) windows"