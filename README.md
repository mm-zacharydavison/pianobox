# pianobox

Provides a pre-configured Pianoteq environment running on:

- Raspberry Pi 4+
- PiSound
- Patchbox OS

# Getting Started

```
git clone git@github.com:mm-zacharydavison/pianobox.git
```

Now follow the **Pianoteq GUI Setup** steps.

# Pianoteq GUI Setup

Currently, it's required to do some steps in the Pianoteq GUI.

You can use a VNC client to remote into the Patchbox OS desktop environment to do these steps.

1. Install and launch Pianoteq and activate your license.
  a. 
  ```bash
  scp pianoteq_stage_linux_v841.7z patch@192.168.178.164:/home/patch/pianobox
  7z x pianoteq_stage_linux_v841.7z
  ```
  b. Open Pianoteq in a graphical environment (e.g. VNC) and activate your license.

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

# Common Issues

### I can't VNC into the Patchbox OS desktop environment.

Add the following to the `~/.bashrc` file:

```bash
export LC_ALL=C
```

Run the `sudo rasp-config`:
- Localisation Options > Locale > en_US.UTF-8 > Apply
- Select `en_US.UTF-8`.
- `sudo reboot`

### Pianoteq is not starting.

- Make sure you have `autologin` for desktop enabled in `sudo raspi-config`.

### I hear pops and crackles when playing.

Your CPU can't keep up with the audio processing.
Some things you can try (I have both, on a Raspberry Pi 4):

1. Overclock your Raspberry Pi CPU:

```bash
# Will overclock your Raspberry Pi CPU to 1800 MHz.
# I get 63-65C temperature while using this.
sudo ./fixes/overclock.sh
```

2. Adjust your Pianoteq settings:

- Internal sample rate: 16,000 Hz
- Maximum Polyphony: 24

