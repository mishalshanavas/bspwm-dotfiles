#!/bin/bash
# Restart eww bar with proper CSS loading

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

# Send notification if notify-send is available
if command -v notify-send >/dev/null 2>&1; then
    notify-send "EWW" "Bar restarted successfully" -i preferences-desktop-theme
fi
sleep 1
cd /home/mishal/.config/eww
eww daemon &
sleep 2
eww open bar
echo "Eww bar restarted with CSS styling!"
