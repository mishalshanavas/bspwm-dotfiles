#!/usr/bin/env bash
# Lock screen with blurred screenshot

# Take screenshot with niri and blur it
niri msg action screenshot-screen
sleep 0.2
latest_screenshot=$(ls -t ~/Pictures/Screenshots/*.png 2>/dev/null | head -n1)

if [ -n "$latest_screenshot" ]; then
    convert "$latest_screenshot" -blur 0x4 ~/.cache/lockscreen-blur.png
    rm "$latest_screenshot"
else
    # Fallback: use solid color if screenshot fails
    convert -size 1920x1080 xc:#1a1a1a ~/.cache/lockscreen-blur.png
fi

# Lock the screen
swaylock
