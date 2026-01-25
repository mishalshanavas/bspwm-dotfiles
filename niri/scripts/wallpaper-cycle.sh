#!/bin/bash
# Wallpaper cycling script for niri/swaybg

WALLPAPER_DIR="$HOME/.config/niri/wallpapers"
STATE_FILE="$HOME/.config/niri/.wallpaper-index"

# Get list of wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | sort)

# Get total count
TOTAL=${#WALLPAPERS[@]}

if [ $TOTAL -eq 0 ]; then
    notify-send "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Read current index
if [ -f "$STATE_FILE" ]; then
    CURRENT=$(cat "$STATE_FILE")
else
    CURRENT=0
fi

# Handle arguments
case "$1" in
    next)
        CURRENT=$(( (CURRENT + 1) % TOTAL ))
        ;;
    prev)
        CURRENT=$(( (CURRENT - 1 + TOTAL) % TOTAL ))
        ;;
    random)
        CURRENT=$(( RANDOM % TOTAL ))
        ;;
    *)
        # Default to next
        CURRENT=$(( (CURRENT + 1) % TOTAL ))
        ;;
esac

# Save new index
echo "$CURRENT" > "$STATE_FILE"

# Get wallpaper path
WALLPAPER="${WALLPAPERS[$CURRENT]}"

# Kill existing swaybg and start new one
pkill swaybg
swaybg -i "$WALLPAPER" -m fill &

# Show notification with wallpaper name
BASENAME=$(basename "$WALLPAPER")
notify-send "Wallpaper" "$BASENAME ($(($CURRENT + 1))/$TOTAL)"
