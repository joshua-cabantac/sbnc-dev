#!/bin/bash
set -euo pipefail

# --- Environment checks ---
echo "XDG_RUNTIME_DIR: ${XDG_RUNTIME_DIR:?not set}"

HYPRLAND_INSTANCE_SIGNATURE="$(hyprctl instances -j | jq -r '.[0].instance')"
echo "HYPRLAND_INSTANCE_SIGNATURE: ${HYPRLAND_INSTANCE_SIGNATURE:?not set}"

SCRIPT="/home/josh/.config/hypr-monitor-hotplug/hypr-monitor-hotplug.sh"
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

echo "Socket path: $SOCK"

# --- Wait for the socket to appear ---
for _ in {1..20}; do
    [ -S "$SOCK" ] && break
    sleep 0.1
done

if [ ! -S "$SOCK" ]; then
    echo "ERROR: IPC socket not found: $SOCK"
    exit 1
fi

LAST_RUN=0
RUN_ONCE=0

echo "Hotplug listener started."

# --- Persistent event listener loop ---
while true; do
    echo "Connecting to IPC socket..."

    while read -r EVENT; do
        echo "EVENT: $EVENT"

        # Run script once on first connection
        if (( RUN_ONCE == 0 )); then
            echo "Running initial hotplug script..."
            "$SCRIPT"
            RUN_ONCE=1
        fi

        case "$EVENT" in
            monitor*)
                now=$(date +%s)
                if (( now - LAST_RUN > 2 )); then
                    echo "Triggering hotplug handler..."
                    "$SCRIPT"
                    LAST_RUN=$now
                fi
                ;;
        esac
    done < <(socat - UNIX-CONNECT:"$SOCK")

    echo "Socket disconnected — reconnecting in 1s..."
    sleep 1
done
