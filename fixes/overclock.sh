#!/bin/bash

CONFIG_FILE="/boot/firmware/config.txt"
OVERCLOCK_SETTINGS="# Overclocking
arm_freq=1800
arm_freq_min=1800"

if ! grep -q "arm_freq=1800" "$CONFIG_FILE"; then
    echo "$OVERCLOCK_SETTINGS" >> "$CONFIG_FILE"
    echo "Overclocking settings added to $CONFIG_FILE"
else
    echo "Overclocking settings already present in $CONFIG_FILE"
fi
