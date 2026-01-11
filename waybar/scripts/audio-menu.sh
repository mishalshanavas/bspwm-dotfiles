#!/bin/bash

# Minimal audio menu for waybar
# Kill any existing fuzzel first
pkill -x fuzzel 2>/dev/null
sleep 0.05

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}'
}

get_mute() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "yes" || echo "no"
}

show_menu() {
    pkill -x fuzzel 2>/dev/null
    sleep 0.05
    
    VOL=$(get_volume)
    MUTED=$(get_mute)
    
    # Volume bar
    FILLED=$((VOL / 10))
    EMPTY=$((10 - FILLED))
    BAR=""
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
    
    MENU=""
    if [[ "$MUTED" == "yes" ]]; then
        MENU+="󰖁 [$BAR] $VOL% (muted)\n"
    else
        MENU+="󰕾 [$BAR] $VOL%\n"
    fi
    MENU+="──────────────\n"
    MENU+="󰝝 +10%\n"
    MENU+="󰝞 -10%\n"
    MENU+="󰖁 Mute\n"
    MENU+="──────────────\n"
    
    # Output devices
    MENU+="󰓃 Output:\n"
    DEFAULT_SINK=$(pactl get-default-sink)
    while read -r sink; do
        name=$(pactl list sinks | grep -A1 "Name: $sink" | grep "Description" | cut -d: -f2 | xargs)
        [[ -z "$name" ]] && name="$sink"
        if [[ "$sink" == "$DEFAULT_SINK" ]]; then
            MENU+="  ● $name\n"
        else
            MENU+="  ○ $name\n"
        fi
    done <<< "$(pactl list sinks short | awk '{print $2}')"
    
    MENU+="──────────────\n"
    
    # Input devices
    MENU+="󰍬 Input:\n"
    DEFAULT_SOURCE=$(pactl get-default-source)
    while read -r source; do
        [[ "$source" == *".monitor" ]] && continue
        name=$(pactl list sources | grep -A1 "Name: $source" | grep "Description" | cut -d: -f2 | xargs)
        [[ -z "$name" ]] && name="$source"
        if [[ "$source" == "$DEFAULT_SOURCE" ]]; then
            MENU+="  ● $name\n"
        else
            MENU+="  ○ $name\n"
        fi
    done <<< "$(pactl list sources short | awk '{print $2}')"

    CHOSEN=$(echo -e "$MENU" | fuzzel --dmenu -p "Audio: ")

    [[ -z "$CHOSEN" ]] && exit 0

    case "$CHOSEN" in
        *"+10%"*) wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+; show_menu ;;
        *"-10%"*) wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-; show_menu ;;
        *"Mute"*) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; show_menu ;;
        *"○"*)
            name=$(echo "$CHOSEN" | sed 's/.*○ //')
            sink=$(pactl list sinks | grep -B1 "Description: $name" | grep "Name:" | awk '{print $2}')
            source=$(pactl list sources | grep -B1 "Description: $name" | grep "Name:" | awk '{print $2}')
            [[ -n "$sink" ]] && pactl set-default-sink "$sink"
            [[ -n "$source" ]] && pactl set-default-source "$source"
            show_menu
            ;;
    esac
}

case "$1" in
    up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    *) show_menu ;;
esac
