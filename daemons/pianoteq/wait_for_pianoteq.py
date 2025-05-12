import time
import logging
import psutil
import os
import sys
# Add the parent directory to the Python path, so we can import the leds module.
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
from leds.lib import set_loading_led, set_loaded_led

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

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
