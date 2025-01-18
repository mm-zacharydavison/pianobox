import time
import logging
import psutil
import os

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

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

def ensure_pianoteq_running():
    pianoteq_process = next((p for p in psutil.process_iter() if "pianoteq" in p.name().lower()), None)
    if not pianoteq_process:
        set_loading_led()
        logging.info("Pianoteq not running. Starting it...")
        try:
            env = os.environ.copy()
            env['DISPLAY'] = ':0'
            env['XAUTHORITY'] = '/home/patch/.Xauthority'
            os.system("sudo systemctl restart pianoteq.service")
        except Exception as e:
            logging.error(f"Failed to start Pianoteq: {e}")
            raise

    start_time = time.time()
    while not next((p for p in psutil.process_iter() if "pianoteq" in p.name().lower()), None):
        if time.time() - start_time > 10:
            logging.error("Pianoteq failed to start within 10 seconds.")
            return
        logging.info("Waiting for Pianoteq to start...")
        time.sleep(1)
    logging.info("Pianoteq process detected.")
    set_loaded_led()

ensure_pianoteq_running()