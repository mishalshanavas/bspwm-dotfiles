#!/bin/bash
# Get battery level
if [ -d "/sys/class/power_supply" ]; then
    for battery in /sys/class/power_supply/BAT*; do
        if [ -f "$battery/capacity" ]; then
            cat "$battery/capacity"
            exit 0
        fi
    done
fi
echo "100"  # Default if no battery found