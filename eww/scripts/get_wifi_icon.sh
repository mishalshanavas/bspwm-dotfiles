#!/bin/bash
# Get WiFi icon based on connection status

# Check if connected to WiFi
if command -v nmcli >/dev/null 2>&1; then
    # Using NetworkManager
    wifi_status=$(nmcli -t -f WIFI g)
    if [ "$wifi_status" = "enabled" ]; then
        connected_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
        if [ -n "$connected_ssid" ]; then
            echo "󰖩"  # Connected WiFi icon (Nerd Font)
        else
            echo "󰖪"  # WiFi disconnected (Nerd Font)
        fi
    else
        echo "󰖪"  # WiFi disabled
    fi
elif command -v iwgetid >/dev/null 2>&1; then
    # Using iwconfig tools
    ssid=$(iwgetid -r 2>/dev/null)
    if [ -n "$ssid" ]; then
        echo "󰖩"  # Connected
    else
        echo "󰖪"  # Not connected
    fi
else
    # Fallback
    echo "󰖩"
fi