#!/bin/bash

# Power menu for waybar
pkill -x fuzzel 2>/dev/null
sleep 0.05

MENU="󰌾 Lock\n"
MENU+="󰍃 Logout\n"
MENU+="󰒲 Suspend\n"
MENU+="󰜉 Reboot\n"
MENU+="󰐥 Shutdown"

CHOSEN=$(echo -e "$MENU" | fuzzel --dmenu -p "Power: ")

[[ -z "$CHOSEN" ]] && exit 0

confirm() {
    pkill -x fuzzel 2>/dev/null
    sleep 0.05
    echo -e "Yes\nNo" | fuzzel --dmenu -p "$1? "
}

case "$CHOSEN" in
    *"Lock"*) swaylock -f ;;
    *"Logout"*) [[ $(confirm "Logout") == "Yes" ]] && (niri msg action quit 2>/dev/null || loginctl terminate-user "$USER") ;;
    *"Suspend"*) swaylock -f && systemctl suspend ;;
    *"Reboot"*) [[ $(confirm "Reboot") == "Yes" ]] && systemctl reboot ;;
    *"Shutdown"*) [[ $(confirm "Shutdown") == "Yes" ]] && systemctl poweroff ;;
esac
