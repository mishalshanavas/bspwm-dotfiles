#!/bin/bash
# Get WiFi connection status and network name

# Check if connected to WiFi
if command -v nmcli >/dev/null 2>&1; then
    # Using NetworkManager
    wifi_status=$(nmcli -t -f WIFI g)
    if [ "$wifi_status" = "enabled" ]; then
        connected_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
        if [ -n "$connected_ssid" ]; then
            # Connected to WiFi - show first 4 chars + ".."
            short_name=$(echo "$connected_ssid" | cut -c1-4)
            if [ ${#connected_ssid} -gt 4 ]; then
                echo "$short_name.."
            else
                echo "$connected_ssid"
            fi
        else
            echo "No WiFi"
        fi
    else
        echo "WiFi Off"
    fi
elif command -v iwgetid >/dev/null 2>&1; then
    # Using iwconfig tools
    ssid=$(iwgetid -r 2>/dev/null)
    if [ -n "$ssid" ]; then
        short_name=$(echo "$ssid" | cut -c1-4)
        if [ ${#ssid} -gt 4 ]; then
            echo "$short_name.."
        else
            echo "$ssid"
        fi
    else
        echo "No WiFi"
    fi
else
    # Fallback
    echo "Unknown"
fi