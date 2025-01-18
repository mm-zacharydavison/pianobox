#!/bin/bash

# Define service files
PIANOTEQ_SERVICE="$(dirname "$0")/pianoteq/pianoteq.service"
VIRTUAL_MIDI_SERVICE="$(dirname "$0")/virtual-midi/virtual-midi.service"

# Define systemd directory
SYSTEMD_DIR="/etc/systemd/system"

# Stop services
sudo systemctl stop pianoteq.service
sudo systemctl stop virtual-midi.service

# remove old logfiles
sudo rm -rf /var/log/pianobox
sudo mkdir -p /var/log/pianobox

# Copy service files to systemd directory
sudo cp $PIANOTEQ_SERVICE $SYSTEMD_DIR
sudo cp $VIRTUAL_MIDI_SERVICE $SYSTEMD_DIR

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable services
sudo systemctl enable pianoteq.service
sudo systemctl enable virtual-midi.service

# Start services
# !!! TODO: Fix JACK server not being available to systemd.
sudo systemctl start pianoteq.service
echo "    --> 'pianoteq.service' installed and started successfully."
sudo systemctl start virtual-midi.service
echo "    --> 'virtual-midi.service' installed and started successfully."