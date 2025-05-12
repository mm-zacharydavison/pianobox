echo '    --> Checking for Pianoteq installation...'
./daemons/pianoteq/install.sh

echo '    --> Installing python requirements...'
sudo apt install python3-pip
# We want the requirements installed into system python, because pisound will be using them too.
sudo python -m pip install -r requirements.txt --break-system-packages

echo '    --> Setting up LED permissions...'
./leds/install.sh

echo '    --> Configuring MIDI button actions...'
./button/configure-buttons.sh

echo '    --> Installing daemons...'
./daemons/install-daemons.sh

echo ' ✓ Done! You may need to reboot if this is your first time running the installer.'