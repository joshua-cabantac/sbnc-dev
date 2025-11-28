#!/bin/bash

DEVICE="$1"

bluetoothctl power on
bluetoothctl trust "$DEVICE"

# Retry until connected
for i in {1..5}; do
    if bluetoothctl connect "$DEVICE"; then
        exit 0
    fi
    sleep 2
done

exit 1
