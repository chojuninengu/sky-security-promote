#!/bin/bash

# Default values
TARGET_IP=""
TARGET_USER=""
PASS_FILE="passwords.txt"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--target-ip) TARGET_IP="$2"; shift ;;
        -u|--target-user) TARGET_USER="$2"; shift ;;
        -p|--pass-file) PASS_FILE="$2"; shift ;;
        -h|--help)
            echo "Usage: $0 -t <TARGET_IP> -u <TARGET_USER> [-p <PASSWORDS_FILE>]"
            exit 0
            ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$TARGET_IP" ] || [ -z "$TARGET_USER" ]; then
    echo "Error: Target IP and Target User are required."
    echo "Usage: $0 -t <TARGET_IP> -u <TARGET_USER> [-p <PASSWORDS_FILE>]"
    exit 1
fi

# Resolve the real user's home directory even when running as root via sudo
if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_HOME="$HOME"
fi

pause() {
    echo ""
    read -rp "Press [Enter] to continue to the next simulation..."
    echo ""
}

echo "[*] Starting attack simulation against $TARGET_IP as user $TARGET_USER"
echo ""

# ── 1/4 FIM ──────────────────────────────────────────────────────────────────
echo "[1/4] Simulating FIM (File Integrity Monitoring) events locally..."
echo "#" >> /etc/pam.conf

pause

# ── 2/4 Malware ───────────────────────────────────────────────────────────────
echo "[2/4] Simulating Malware Download (EICAR) locally..."
DOWNLOADS_DIR="$REAL_HOME/Downloads"
mkdir -p "$DOWNLOADS_DIR"
curl -s https://www.cybersoft.com/static/downloads/eicar/eicar2.com -o "$DOWNLOADS_DIR/eicar2.com"
echo "[+] Malware download simulation complete. File saved to $DOWNLOADS_DIR/eicar2.com"

pause

# ── 3/4 Nmap ──────────────────────────────────────────────────────────────────
echo "[3/4] Simulating Network Reconnaissance (Nmap) against $TARGET_IP..."
nmap -sV "$TARGET_IP"
echo "[+] Nmap scan complete."

pause

# ── 4/4 Brute-force ───────────────────────────────────────────────────────────
echo "[4/4] Simulating Brute-Force Attack against $TARGET_IP..."
if [ ! -f "$PASS_FILE" ]; then
    echo "[-] Password file $PASS_FILE not found. Creating a dummy one for the demo."
    echo -e "123456\npassword\nadmin\ninvalidpass\nqwerty" > "$PASS_FILE"
fi
hydra -l "$TARGET_USER" -P "$PASS_FILE" ssh://"$TARGET_IP" -t 4
echo "[+] Brute-force simulation complete."
echo ""

echo "[*] All attack simulations completed."
