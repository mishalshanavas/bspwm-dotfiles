#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# 🔄 EWW RESTART SCRIPT - Modern r/unixporn Setup
# ═══════════════════════════════════════════════════════════════════

echo "Restarting EWW bar..."

# Kill EWW processes
pkill eww 2>/dev/null
eww kill 2>/dev/null

# Wait for clean shutdown
sleep 2

# Restart using the start script
~/.config/eww/start.sh

# Send notification if available
if command -v notify-send >/dev/null 2>&1; then
    notify-send "EWW" "Bar restarted successfully" -i preferences-desktop-theme
fi
