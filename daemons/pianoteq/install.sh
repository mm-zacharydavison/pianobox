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
DEFAULT_PIANOTEQ="/home/patch/pianobox/Pianoteq 8 STAGE/arm-64bit/Pianoteq 8 STAGE"
if [ ! -f "$START_PIANOTEQ_SCRIPT" ]; then
    echo "! --> If you haven't followed the 'Pianoteq GUI Setup' steps in the README.md, do it now before continuing."
    echo "  --> Press Enter to continue..."
    read -r
    if [ -f "$DEFAULT_PIANOTEQ" ]; then
        PIANOTEQ_EXECUTABLE="$DEFAULT_PIANOTEQ"
        echo "  --> Using default Pianoteq path: $DEFAULT_PIANOTEQ"
    else
        echo "  --> Default Pianoteq path not found at: $DEFAULT_PIANOTEQ"
        echo "  --> Please enter the absolute path of your Pianoteq executable:"
        read PIANOTEQ_EXECUTABLE
    fi
    echo "#!/bin/bash" > "$START_PIANOTEQ_SCRIPT"
    # Assign CPU Cores 2+3 to Pianoteq (improve performance)
    # @see https://forum.modartt.com/viewtopic.php?id=8265
    echo "taskset -c 2,3 $PIANOTEQ_EXECUTABLE" >> "$START_PIANOTEQ_SCRIPT"
    chmod +x "$START_PIANOTEQ_SCRIPT"
    echo "  --> start_pianoteq script created at $START_PIANOTEQ_SCRIPT"
fi