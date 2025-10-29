#!/bin/bash
# Get battery icon based on level and charging state

# Check if battery exists
if [ ! -d "/sys/class/power_supply" ]; then
    echo "󰂑"  # No battery icon
    exit 0
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

# Exit if no battery found
if [ -z "$battery_path" ]; then
    echo "󰂑"  # No battery
    exit 0
fi

# Get battery level
battery_level=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")

# Check if charging
charging=false
if [ -f "$battery_path/status" ]; then
    status=$(cat "$battery_path/status")
    if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
        charging=true
    fi
fi

# Alternative check with AC adapter
if [ "$charging" = false ] && [ -n "$ac_path" ] && [ -f "$ac_path/online" ]; then
    ac_online=$(cat "$ac_path/online")
    if [ "$ac_online" = "1" ]; then
        charging=true
    fi
fi

# Choose icon based on level and charging state
if [ "$charging" = true ]; then
    # Charging icons
    if [ "$battery_level" -ge 90 ]; then
        echo "󰂅"  # Battery charging full
    elif [ "$battery_level" -ge 70 ]; then
        echo "󰂋"  # Battery charging high
    elif [ "$battery_level" -ge 50 ]; then
        echo "󰂊"  # Battery charging medium
    elif [ "$battery_level" -ge 30 ]; then
        echo "󰂉"  # Battery charging low
    else
        echo "󰂆"  # Battery charging critical
    fi
else
    # Not charging icons
    if [ "$battery_level" -ge 90 ]; then
        echo "󰁹"  # Battery full
    elif [ "$battery_level" -ge 70 ]; then
        echo "󰂀"  # Battery high
    elif [ "$battery_level" -ge 50 ]; then
        echo "󰁾"  # Battery medium
    elif [ "$battery_level" -ge 30 ]; then
        echo "󰁻"  # Battery low
    elif [ "$battery_level" -ge 10 ]; then
        echo "󰁺"  # Battery very low
    else
        echo "󰂎"  # Battery critical
    fi
fi