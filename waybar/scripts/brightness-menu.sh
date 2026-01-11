#!/bin/bash

# Brightness menu for waybar (min 15%)
pkill -x fuzzel 2>/dev/null
sleep 0.05

MIN=15

get_brightness() {
    brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'
}

set_brightness() {
    local val=$1
    [[ $val -lt $MIN ]] && val=$MIN
    [[ $val -gt 100 ]] && val=100
    brightnessctl set ${val}%
}

show_menu() {
    pkill -x fuzzel 2>/dev/null
    sleep 0.05
    
    BRIGHT=$(get_brightness)
    
    FILLED=$((BRIGHT / 10))
    EMPTY=$((10 - FILLED))
    BAR=""
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
    
    MENU="󰃠 [$BAR] $BRIGHT%\n"
    MENU+="──────────────\n"
    MENU+="󰃠 100%\n"
    MENU+="󰃟 75%\n"
    MENU+="󰃟 50%\n"
    MENU+="󰃞 25%\n"
    MENU+="󰃞 15%\n"
    MENU+="──────────────\n"
    MENU+="󱩎 +10%\n"
    MENU+="󱩐 -10%"

    CHOSEN=$(echo -e "$MENU" | fuzzel --dmenu -p "Brightness: ")
    [[ -z "$CHOSEN" ]] && exit 0

    case "$CHOSEN" in
        *"100%"*) set_brightness 100 ;;
        *"75%"*) set_brightness 75 ;;
        *"50%"*) set_brightness 50 ;;
        *"25%"*) set_brightness 25 ;;
        *"15%"*) set_brightness 15 ;;
        *"+10%"*) set_brightness $(($(get_brightness) + 10)); show_menu ;;
        *"-10%"*) set_brightness $(($(get_brightness) - 10)); show_menu ;;
    esac
}

case "$1" in
    up) set_brightness $(($(get_brightness) + 5)) ;;
    down) set_brightness $(($(get_brightness) - 5)) ;;
    *) show_menu ;;
esac
