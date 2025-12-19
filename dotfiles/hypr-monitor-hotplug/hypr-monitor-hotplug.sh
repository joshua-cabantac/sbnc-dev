#!/bin/bash

LOG="/tmp/hypr-hotplug.log"
exec > >(tee -a "$LOG") 2>&1
echo $(date)

# -----------------------------
# CONFIG
# -----------------------------
INTERNAL="LVDS-1"
EXTERNAL="VGA-1"

sleep 7
# -----------------------------
# Locate Hyprland instance & sockets
# -----------------------------
R="$XDG_RUNTIME_DIR/hypr"
HIS=$(ls "$R" | head -n1)
CMDSOCK="$R/$HIS/.socket.sock"
EVENTSOCK="$R/$HIS/.socket2.sock"

log() {
    echo "$(date)  $*" >> "$LOG"
}

send() {
    log "CMD: $*"
    echo "$*" | socat - UNIX-CONNECT:"$CMDSOCK"
}

log "Hotplug daemon started for instance: $HIS"

# -----------------------------
# Initial state sync on startup
# -----------------------------
apply_layout() {
    CONNECTED=$(hyprctl -j monitors | jq -r '.[].name')

    EXT_PRESENT=false
    for M in $CONNECTED; do
        [[ "$M" == "$EXTERNAL" ]] && EXT_PRESENT=true
    done

    if $EXT_PRESENT; then
        log "→ External connected"
        # Do NOT wrap the monitor string in quotes; Hyprland treats quoted
        # comma-separated fields as a single literal and fails to parse.
        send "keyword monitor $EXTERNAL,preferred,auto,1"
        send "keyword monitor $INTERNAL,disable"
        TARGET="$EXTERNAL"
    else
        log "→ External disconnected"

        send "keyword monitor $INTERNAL,preferred,auto,1"
	send "dispatch dpms on"
        TARGET="$INTERNAL"
    fi

	sleep 1
    # Move workspaces
    WS=$(hyprctl -j workspaces | jq -r '.[].id')
    for W in $WS; do
        send "dispatch moveworkspacetomonitor $W $TARGET"
    done

    # Reload waybar after layout change
ts=$(date +%s)
#debounce_restart_waybar "$ts"
}
DEBOUNCE_FILE="/tmp/hypr-hotplug-debounce"

debounce_restart_waybar() {
  local ts
    ts=$(date +%s%N)

    echo "$ts" > "$DEBOUNCE_FILE"

    (
        sleep 5  # debounce window (tweakable!)

        # Check if the timestamp is still ours
        if [[ "$(cat "$DEBOUNCE_FILE")" == "$1" ]]; then
            echo "Debounced: restarting waybar now" >> "$LOG"
            systemctl --user restart waybar.service
        fi
    ) &
}

# Run initial sync
apply_layout

# -----------------------------
# EVENT LISTENER LOOP
# -----------------------------
socat -U - UNIX-CONNECT:"$EVENTSOCK" | while read -r event; do
    log "EVENT: $event"

    case "$event" in

        monitoradded*,*)
            log "Monitor added → reapply layout"
            apply_layout
        ;;

        monitorremoved*,*)
            log "Monitor removed → reapply layout"
            apply_layout
        ;;

    esac
done
