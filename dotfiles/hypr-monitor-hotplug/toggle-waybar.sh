#!/bin/bash

SERVICE="waybar.service"

# Check current state
STATE=$(systemctl --user is-active "$SERVICE")

if [[ "$STATE" == "active" ]]; then
    echo "Waybar is running → stopping it..."
    systemctl --user stop "$SERVICE"
else
    echo "Waybar is not running → starting it..."
    systemctl --user start "$SERVICE"
fi
