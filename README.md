# pianobox

Provides a pre-configured Pianoteq environment running on:

- Raspberry Pi 4+
- PiSound
- Patchbox OS

# Getting Started

```
git clone git@github.com:mm-zacharydavison/pianobox.git
```

Now follow the **Pianoteq GUI Configuration** steps.

# Pianoteq GUI Configuration

Currently, it's required to do some steps in the Pianoteq GUI.

You can use a VNC client to remote into the Patchbox OS desktop environment to do these steps.

1. Install and launch Pianoteq and activate your license.
2. Run the `install.sh` script.
2. Edit > Preferences > Instruments: Hide all instrument packs you don't own.
3. Edit > Preferences > MIDI: Select the 'pianobox' MIDI preset and set it as default.
4. Edit > Preferences > Devices: Ensure Pianoteq is receiving MIDI from all inputs (or at least the Virtual MIDI input and whatever input you want)

# Features

- One command installer.
- Pianoteq runs as a systemd service and will always be running so long as your Pi is powered on.
- LED will go green when Pianoteq is launched (it's a little bit before it's ready to receive MIDI and play audio, however)
- Virtual MIDI port systemd service creates a virtual MIDI port which can be used via the button.
- Press button once for Next Preset.
- Press button twice for Next Instrument.