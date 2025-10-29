#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# 🚀 EWW STARTUP SCRIPT - Modern r/unixporn Setup
# ═══════════════════════════════════════════════════════════════════

# Kill any existing EWW instances
pkill eww 2>/dev/null
eww kill 2>/dev/null

# Wait a moment for processes to terminate
sleep 1

# Change to eww config directory
cd /home/mishal/.config/eww

# Ensure scripts are executable
chmod +x ~/.config/eww/scripts/*

# Start EWW daemon
eww daemon &
sleep 2

# Open the bar
eww open bar

echo "Modern EWW bar started successfully!"