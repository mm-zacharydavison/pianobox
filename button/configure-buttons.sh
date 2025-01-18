#!/bin/bash

echo '    --> Configuring buttons in /etc/pisound.conf'

# Define paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PISOUND_SCRIPTS_DIR="/usr/local/pisound/scripts/pisound-btn"
NEW_CLICK_1_PATH="$PISOUND_SCRIPTS_DIR/send_midi_program_change_1.sh"
NEW_CLICK_2_PATH="$PISOUND_SCRIPTS_DIR/send_midi_program_change_2.sh"

# Create symlinks
sudo ln -sf "$SCRIPT_DIR/send_midi_program_change_1.sh" "$NEW_CLICK_1_PATH"
sudo ln -sf "$SCRIPT_DIR/send_midi_program_change_2.sh" "$NEW_CLICK_2_PATH"

# Backup the original file
sudo cp /etc/pisound.conf /etc/pisound.conf.bak
echo '    --> Backed up original file to /etc/pisound.conf.bak'

# Use sed to replace the paths
sudo sed -i "s|^\(CLICK_1\s*\).*|\1$NEW_CLICK_1_PATH|" /etc/pisound.conf
sudo sed -i "s|^\(CLICK_2\s*\).*|\1$NEW_CLICK_2_PATH|" /etc/pisound.conf

echo "    --> Buttons configured successfully."