#!/bin/bash
# Get detailed network information for tooltip

# Check if connected to WiFi
if command -v nmcli >/dev/null 2>&1; then
    # Using NetworkManager
    wifi_status=$(nmcli -t -f WIFI g)
    if [ "$wifi_status" = "enabled" ]; then
        # Get active connection info
        active_connection=$(nmcli -t -f active,ssid,signal,freq,security dev wifi | grep '^yes')
        if [ -n "$active_connection" ]; then
            ssid=$(echo "$active_connection" | cut -d: -f2)
            signal=$(echo "$active_connection" | cut -d: -f3)
            freq=$(echo "$active_connection" | cut -d: -f4)
            security=$(echo "$active_connection" | cut -d: -f5)
            
            # Get IP address
            ip_addr=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+' || echo "N/A")
            
            # Format tooltip
            echo "Network: $ssid
Signal: $signal%
Frequency: ${freq} MHz
Security: $security
IP: $ip_addr"
        else
            echo "WiFi enabled but not connected"
        fi
    else
        echo "WiFi disabled"
    fi
elif command -v iwgetid >/dev/null 2>&1; then
    # Using iwconfig tools
    ssid=$(iwgetid -r 2>/dev/null)
    if [ -n "$ssid" ]; then
        # Get signal strength
        interface=$(iwconfig 2>/dev/null | grep -o '^[a-zA-Z0-9]*' | head -1)
        if [ -n "$interface" ]; then
            signal_info=$(iwconfig "$interface" 2>/dev/null | grep 'Signal level')
            ip_addr=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+' || echo "N/A")
            
            echo "Network: $ssid
$signal_info
IP: $ip_addr"
        else
            echo "Network: $ssid"
        fi
    else
        echo "No WiFi connection"
    fi
else
    # Fallback
    ip_addr=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+' || echo "N/A")
    echo "Network connection
IP: $ip_addr"
fi