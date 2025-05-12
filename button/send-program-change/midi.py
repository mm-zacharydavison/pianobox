import argparse
import logging
import subprocess
import time
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

def get_virmidi_port():
    try:
        result = subprocess.run(['aconnect', '-l'], capture_output=True, text=True)
        for line in result.stdout.split('\n'):
            if 'VirMIDI' in line:
                client_id = line.split()[1].strip(':')
                port_id = '0'
                return f'{client_id}:{port_id}'
        raise ValueError("No VirMIDI port found.")
    except Exception as e:
        logging.error(f"Failed to find VirMIDI port: {e}")
        raise

# This probably won't work if you have advanced usage in future.
def get_all_port():
  return 'hw:4,0,0'

def send_program_change(port, program_number):
    try:
        hex_program = format(program_number - 1, '02X')
        subprocess.run(['amidi', '-p', port, '-S', f'C0 {hex_program}'], check=True)
        logging.info(f"Sent Program Change {program_number} to output port")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to send Program Change: {e}")

def send_note_on(port):
    try:
        subprocess.run(['amidi', '-p', port, '-S', '90 3C 40'], check=True)
        logging.info("Sent NOTE ON for C4 (note number 60) with velocity 64 to output port")
    except subprocess.CalledProcessError as e:
        logging.error(f"Failed to send NOTE ON: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send a MIDI Program Change or C4 NOTE ON using amidi.")
    parser.add_argument(
        "program_change_number",
        type=int,
        nargs='?',
        help="The MIDI Program Change number (1-128) to send. If omitted, a C4 NOTE ON message will be sent."
    )
    args = parser.parse_args()

    try:
        ensure_pianoteq_running()
        port = get_all_port()

        if args.program_change_number is None:
            send_note_on(port)
        elif 1 <= args.program_change_number <= 128:
            send_program_change(port, args.program_change_number)
        else:
            logging.error("Error: Program Change number must be between 1 and 128.")

    except Exception as e:
        logging.error(f"An error occurred: {e}")
