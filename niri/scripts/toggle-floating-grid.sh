#!/bin/bash

# Get focused workspace ID
focused_ws=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused == true) | .id')

# Get all windows on focused workspace with their floating state
data=$(niri msg -j windows | jq --arg ws "$focused_ws" '[.[] | select(.workspace_id == ($ws | tonumber)) | {id, is_floating}]')

# Get window IDs
ids=($(echo "$data" | jq -r '.[].id'))
count=${#ids[@]}

if [ $count -eq 0 ]; then
    exit 0
fi

# Count floating windows
floating_count=$(echo "$data" | jq '[.[] | select(.is_floating == true)] | length')

# If ANY are floating, toggle ALL back to tiling
if [ "$floating_count" -gt 0 ]; then
    for id in "${ids[@]}"; do
        is_float=$(echo "$data" | jq -r --arg id "$id" '.[] | select(.id == ($id | tonumber)) | .is_floating')
        if [ "$is_float" = "true" ]; then
            niri msg action set-window-height --id "$id" 100% 2>/dev/null
            niri msg action toggle-window-floating --id "$id" 2>/dev/null
        fi
    done
    exit 0
fi

# If we get here, all windows are tiling - make them floating diagonal

# Window settings (16:9 ratio, small size)
w=720
h=405
offset=50

# Process each window
i=0
first_x=0
first_y=0

for id in "${ids[@]}"; do
    # Toggle to floating
    niri msg action toggle-window-floating --id "$id"
    sleep 0.05
    
    # Resize
    niri msg action set-window-width --id "$id" "$w"
    niri msg action set-window-height --id "$id" "$h"
    sleep 0.05
    
    if [ $i -eq 0 ]; then
        # First window - get its position and use as reference
        pos=$(niri msg -j windows | jq -r --arg id "$id" '.[] | select(.id == ($id | tonumber)) | .layout.tile_pos_in_workspace_view')
        first_x=$(echo "$pos" | jq -r '.[0] // 0' | cut -d. -f1)
        first_y=$(echo "$pos" | jq -r '.[1] // 0' | cut -d. -f1)
    else
        # Subsequent windows - move relative to first window
        move_x=$((i * offset))
        move_y=$((i * offset))
        
        niri msg action move-floating-window --id "$id" --x "$move_x" --y "$move_y"
    fi
    
    i=$((i + 1))
done
