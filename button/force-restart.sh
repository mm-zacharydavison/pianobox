#!/bin/bash

# Useful for forcibly restarting everything via button press, incase something is broken.

echo '!. --> Force Restarting...'
# Restart JACK server
echo "1. --> Killing Pianoteq..."
pkill -f pianoteq

echo "2. --> Restarting JACK server..."
sudo systemctl restart jack.service

echo '3. --> Re-installing daemons...'
$(dirname "$0")/../daemons/install-daemons.sh
