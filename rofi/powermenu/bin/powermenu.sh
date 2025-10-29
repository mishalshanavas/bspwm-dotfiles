#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# ⚫ MINIMAL POWER MENU - Working Actions
# ═══════════════════════════════════════════════════════════════════

# Simple power menu options
options="󰐥 Shutdown\n󰜉 Reboot\n󰍃 Logout\n󰒲 Suspend\n󰌾 Lock"

# Show the power menu
chosen=$(echo -e "$options" | rofi -dmenu \
    -p "Power Menu" \
    -lines 5 \
    -width 300 \
    -height 200 \
    -no-fixed-num-lines \
    -theme-str 'window {width: 300px; height: 200px;}')

# Execute the chosen option
case "$chosen" in
    "󰐥 Shutdown")
        systemctl poweroff
        ;;
    "󰜉 Reboot")
        systemctl reboot
        ;;
    "󰍃 Logout")
        bspc quit
        ;;
    "󰒲 Suspend")
        systemctl suspend
        ;;
    "󰌾 Lock")
        if command -v i3lock >/dev/null 2>&1; then
            i3lock -c 000000
        elif command -v xlock >/dev/null 2>&1; then
            xlock
        elif command -v gnome-screensaver-command >/dev/null 2>&1; then
            gnome-screensaver-command -l
        else
            notify-send "Lock" "No lock screen available"
        fi
        ;;
esac