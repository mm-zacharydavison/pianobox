#!/bin/bash

# Copy MIDI preset.
MIDI_PRESET="/home/patch/pianobox/daemons/pianoteq/pianobox.ptm"
MIDI_PRESET_INSTALL_DIR="/home/patch/.local/share/Modartt/Pianoteq/MidiMappings"
MIDI_PRESET_INSTALL_LOCATION="$MIDI_PRESET_INSTALL_DIR/pianobox.ptm"
if [ ! -f "$MIDI_PRESET_INSTALL_LOCATION" ]; then
  echo "  --> Installing pianobox.ptm MIDI mapping file..."
  mkdir -p "$MIDI_PRESET_INSTALL_DIR"
  cp "$MIDI_PRESET" "$MIDI_PRESET_INSTALL_LOCATION"
fi

# Check for Pianoteq installation.
START_PIANOTEQ_SCRIPT="/home/patch/pianobox/daemons/pianoteq/start_pianoteq"
if [ ! -f "$START_PIANOTEQ_SCRIPT" ]; then
    echo "  --> start_pianoteq script not found. Please enter the absolute path of your Pianoteq executable:"
    echo "! --> If you haven't followed the 'Pianoteq GUI Setup' steps in the README.md, do it now before continuing.'
    read PIANOTEQ_EXECUTABLE
    echo "#!/bin/bash" > "$START_PIANOTEQ_SCRIPT"
    echo "$PIANOTEQ_EXECUTABLE" >> "$START_PIANOTEQ_SCRIPT"
    chmod +x "$START_PIANOTEQ_SCRIPT"
    echo "  --> start_pianoteq script created at $START_PIANOTEQ_SCRIPT"
fi