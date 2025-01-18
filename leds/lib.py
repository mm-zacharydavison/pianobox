def set_loading_led():
    """Set LEDs to indicate that something is loading."""
    set_led_trigger('PWR', 'heartbeat')
    set_led_trigger('ACT', 'none')
    set_led('PWR', 1)
    set_led('ACT', 1)

def set_loaded_led():
    """Set LEDs to indicate that everything is loaded and stable."""
    set_led_trigger('PWR', 'none')
    set_led_trigger('ACT', 'none')
    set_led('PWR', 0)
    set_led('ACT', 1)

def set_led(led_name, value):
    """Set LED brightness (0 = OFF, 1 = ON)"""
    path = f"/sys/class/leds/{led_name}/brightness"
    try:
        with open(path, "w") as f:
            f.write(str(value))
    except PermissionError:
        print(f"Permission denied. Try running as sudo: {path}")

def set_led_trigger(led_name, trigger):
    """Change LED trigger mode (e.g., 'heartbeat', 'none', 'mmc0')"""
    path = f"/sys/class/leds/{led_name}/trigger"
    try:
        with open(path, "w") as f:
            f.write(trigger)
    except PermissionError:
        print(f"Permission denied. Try running as sudo: {path}")
