import os
import time
import pyperclip
import subprocess
import pyotp
import re
import argparse
from pathlib import Path


def notify(message):
    subprocess.Popen(f"notify-send '{message}'", shell=True)


def parse_pass_entry(entry_text):
    lines = entry_text.strip().splitlines()
    password = lines[0] if lines else ""
    username = None
    otp_url = None

    for line in lines[1:]:
        if line.startswith("Username:"):
            username = line.replace("Username:", "").strip()
        elif line.startswith("otpauth://"):
            otp_url = line.strip()

    return password, username, otp_url


def get_otp_from_url(otp_url):
    match = re.search(r"secret=([A-Z2-7]+)", otp_url)
    if match:
        secret = match.group(1)
        totp = pyotp.TOTP(secret)
        return totp.now()
    return None


def get_pass_entries(store_dir):
    entries = []
    for root, _, files in os.walk(store_dir):
        for file in files:
            if file.endswith('.gpg'):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, store_dir)
                entry = rel_path.replace('.gpg', '').replace('\\', '/')
                entries.append(entry)
    return entries


def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Password/OTP retriever")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--otp", action="store_true",
                       help="Copy OTP code to clipboard")
    group.add_argument("--username", action="store_true",
                       help="Copy username to clipboard")
    group.add_argument("--password", action="store_true",
                       help="Copy password to clipboard (default)")

    args = parser.parse_args()

    # Locate password store
    home = Path.home()
    store = os.path.join(home, '.password-store')

    # Get all pass entries
    entries = get_pass_entries(store)
    file_list = "\n".join(entries)

    # Use rofi to choose an entry
    shell_rofi = subprocess.Popen(
        f"echo '{file_list}' | rofi -dmenu", shell=True, stdout=subprocess.PIPE)

    file, _ = shell_rofi.communicate()
    file = file.decode().strip()

    if not file:
        notify("No entry selected")
        exit(1)

    full_path = os.path.join(store, f"{file}.gpg")
    if not os.path.exists(full_path):
        notify(f"Failed to open file: {file}")
        exit(1)

    # Decrypt entry using `pass`
    shell_pass = subprocess.Popen(
        f"pass {file}", shell=True, stdout=subprocess.PIPE)

    output, _ = shell_pass.communicate()
    output = output.decode()

    password, username, otp_url = parse_pass_entry(output)

    # Handle selection
    if args.otp:
        if otp_url:
            otp = get_otp_from_url(otp_url)
            if otp:
                pyperclip.copy(otp)
                notify(f"OTP for {file} copied to clipboard")
            else:
                notify("Failed to generate OTP")
                exit(1)
        else:
            notify("No OTP secret found")
            exit(1)

    elif args.username:
        if username:
            pyperclip.copy(username)
            notify(f"Username for {file} copied to clipboard")
        else:
            notify("No username found")
            exit(1)

    else:  # Default: password
        pyperclip.copy(password)
        notify(f"Password for {file} copied to clipboard")

    # Clear clipboard after 30 seconds
    time.sleep(30)
    pyperclip.copy("")


if __name__ == "__main__":
    main()
