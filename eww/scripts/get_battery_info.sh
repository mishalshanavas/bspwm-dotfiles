#!/bin/bash
# Combined battery info script - outputs level and icon in one call
# Usage: get_battery_info.sh [level|icon]

get_battery_data() {
    # Check if battery exists
    if [ ! -d "/sys/class/power_supply" ]; then
        battery_level="100"; charging="false"
        return
    fi

    # Find battery and AC adapter
    battery_path=""
    ac_path=""
    
    for power_supply in /sys/class/power_supply/*; do
        if [ -f "$power_supply/type" ]; then
            type=$(cat "$power_supply/type")
            if [ "$type" = "Battery" ] && [ -f "$power_supply/capacity" ]; then
                battery_path="$power_supply"
            elif [ "$type" = "Mains" ] || [ "$type" = "ADP1" ]; then
                ac_path="$power_supply"
            fi
        fi
    done

    # Get battery level
    if [ -n "$battery_path" ]; then
        battery_level=$(cat "$battery_path/capacity" 2>/dev/null || echo "100")
    else
        battery_level="100"
    fi

    # Check if charging
    charging="false"
    if [ -n "$battery_path" ] && [ -f "$battery_path/status" ]; then
        status=$(cat "$battery_path/status")
        if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
            charging="true"
        fi
    fi

    # Alternative check with AC adapter
    if [ "$charging" = "false" ] && [ -n "$ac_path" ] && [ -f "$ac_path/online" ]; then
        ac_online=$(cat "$ac_path/online")
        if [ "$ac_online" = "1" ]; then
            charging="true"
        fi
    fi
}

case "$1" in
    "percentage")
        get_battery_data
        echo "$battery_level"
        ;;
    "icon")
        get_battery_data
        if [ "$charging" = "true" ]; then
            # Charging icons
            if [ "$battery_level" -ge 90 ]; then
                echo "󰂅"
            elif [ "$battery_level" -ge 70 ]; then
                echo "󰂋"
            elif [ "$battery_level" -ge 50 ]; then
                echo "󰂊"
            elif [ "$battery_level" -ge 30 ]; then
                echo "󰂉"
            else
                echo "󰂆"
            fi
        else
            # Not charging icons
            if [ "$battery_level" -ge 90 ]; then
                echo "󰁹"
            elif [ "$battery_level" -ge 70 ]; then
                echo "󰂀"
            elif [ "$battery_level" -ge 50 ]; then
                echo "󰁾"
            elif [ "$battery_level" -ge 30 ]; then
                echo "󰁻"
            elif [ "$battery_level" -ge 10 ]; then
                echo "󰁺"
            else
                echo "󰂎"
            fi
        fi
        ;;
    *)
        echo "Usage: $0 [percentage|icon]"
        ;;
esac