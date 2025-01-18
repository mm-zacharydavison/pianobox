#!/bin/bash

# Configure LED permissions so anyone can change the LED status.
# This makes it easier for python scripts etc to change LEDs.

echo 'SUBSYSTEM=="leds", ACTION=="add", RUN+="/bin/chmod 0666 /sys/class/leds/%k/brightness"' | sudo tee /etc/udev/rules.d/99-leds.rules
echo 'SUBSYSTEM=="leds", ACTION=="add", RUN+="/bin/chmod 0666 /sys/class/leds/%k/trigger"' | sudo tee -a /etc/udev/rules.d/99-leds.rules
sudo udevadm control --reload-rules
sudo udevadm trigger