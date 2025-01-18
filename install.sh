echo '1. Checking for Pianoteq installation...'
START_PIANOTEQ_SCRIPT="/home/patch/pianobox/daemons/pianoteq/start_pianoteq"
if [ ! -f "$START_PIANOTEQ_SCRIPT" ]; then
    echo "start_pianoteq script not found. Please enter the absolute path of your Pianoteq executable:"
    read PIANOTEQ_EXECUTABLE
    echo "#!/bin/bash" > "$START_PIANOTEQ_SCRIPT"
    echo "$PIANOTEQ_EXECUTABLE" >> "$START_PIANOTEQ_SCRIPT"
    chmod +x "$START_PIANOTEQ_SCRIPT"
    echo "start_pianoteq script created at $START_PIANOTEQ_SCRIPT"
fi

echo '    --> Installing python requirements...'
# We want the requirements installed into system python, because pisound will be using them too.
pip install -r requirements.txt --break-system-packages

echo '    --> Setting up LED permissions...'
./leds/install.sh

echo '    --> Installing daemons...'
./daemons/install-daemons.sh

echo '    --> Configuring MIDI button actions...'
./button/configure-buttons.sh

echo ' ✓ Done! You may need to reboot if this is your first time running the installer.'