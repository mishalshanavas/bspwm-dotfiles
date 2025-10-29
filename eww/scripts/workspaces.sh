#!/bin/bash
# Workspace listener for bspwm with dots

generate_workspaces() {
    workspaces=""
    current=$(bspc query -D -d focused --names 2>/dev/null || echo "1")
    
    for i in {1..10}; do
        if [ "$i" = "$current" ]; then
            class="focused"
            dot="●"  # Filled dot for focused
        elif bspc query -N -d "$i" | grep -q .; then
            class="occupied" 
            dot="●"  # Filled dot for occupied
        else
            class="empty"
            dot="○"  # Outline dot for empty
        fi
        
        workspaces="${workspaces}(button :class \"workspaces $class\" :onclick \"bspc desktop -f $i\" \"$dot\")"
    done
    
    echo "(box :class \"workspaces\" :space-evenly false $workspaces)"
}

# Output initial state
generate_workspaces

# Listen for changes
bspc subscribe desktop_focus node_add node_remove | while read -r event; do
    generate_workspaces
done