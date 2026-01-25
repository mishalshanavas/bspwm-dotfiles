#!/usr/bin/env bash
# Lock screen with blurred screenshot

# Prevent multiple instances
if pgrep -x swaylock > /dev/null; then
    exit 0
fi

# Create cache directory if it doesn't exist
mkdir -p ~/.cache

# Take screenshot using grim (more reliable than niri screenshot)
screenshot_file="/tmp/lockscreen-$(date +%s).png"
grim "$screenshot_file"

# Check if grim succeeded and blur the screenshot
if [ -f "$screenshot_file" ]; then
    # Use ffmpeg for blur (faster than ImageMagick)
    ffmpeg -i "$screenshot_file" -vf "gblur=sigma=20" -y ~/.cache/lockscreen-blur.png 2>/dev/null
    
    # Fallback to ImageMagick if ffmpeg fails
    if [ $? -ne 0 ] && command -v convert &> /dev/null; then
        convert "$screenshot_file" -blur 0x8 ~/.cache/lockscreen-blur.png
    fi
    
    rm "$screenshot_file"
else
    # Fallback: create solid color if screenshot fails
    if command -v convert &> /dev/null; then
        convert -size 1366x768 xc:#1a1a1a ~/.cache/lockscreen-blur.png
    else
        # If no tools available, swaylock will use solid color from config
        :
    fi
fi

# Lock the screen
swaylock
