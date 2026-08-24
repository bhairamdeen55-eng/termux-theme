#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  TEAMVB LOGIN SCREEN - fully self-contained
# ============================================

THEME_DIR="$HOME/.termux-theme"
CRED_FILE="$THEME_DIR/.creds"
RED='\e[1;31m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
RESET='\e[0m'

print_big_banner() {
    echo -e "$GREEN"
    if command -v toilet >/dev/null 2>&1; then
        toilet -f pagga "TEAMVB" 2>/dev/null || toilet -f big "TEAMVB"
    elif command -v figlet >/dev/null 2>&1; then
        figlet -f big "TEAMVB"
    else
        echo "  ████████╗███████╗ █████╗ ███╗   ███╗██╗   ██╗██████╗"
        echo "     ██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║██╔══██╗"
        echo "     ██║   █████╗  ███████║██╔████╔██║██║   ██║██████╔╝"
        echo "     ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║╚██╗ ██╔╝██╔══██╗"
        echo "     ██║   ███████╗██║  ██║██║ ╚═╝ ██║ ╚████╔╝ ██████╔╝"
        echo "     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═══╝  ╚═════╝"
    fi
    echo -e "$RESET"
}

print_login_subtitle() {
    echo -e "${RED}================================================${RESET}"
    echo -e "${BLUE}        TEAMVB AGENT LOGIN PANEL${RESET}"
    echo -e "${RED}================================================${RESET}"
}

boot_sequence() {
    local VOICE_MESSAGE="Welcome back TEAMVB servers, I hope you are fine"
    clear
    echo -e "$GREEN"
    if command -v termux-tts-speak >/dev/null 2>&1; then
        termux-tts-speak "$VOICE_MESSAGE" >/dev/null 2>&1 &
    else
        echo -e "${RED}[!] Voice disabled: install the 'Termux:API' app from Play Store / F-Droid${RESET}"
        echo ""
    fi
    local BOOT_LINES=(
        "[  OK  ] Initializing TEAMVB secure shell..."
        "[  OK  ] Mounting encrypted filesystem..."
        "[  OK  ] Loading network interfaces..."
        "[  OK  ] Establishing secure tunnel..."
        "[  OK  ] Verifying agent credentials..."
        "[  OK  ] Syncing team keys..."
        "[  OK  ] Checking server integrity..."
        "[  OK  ] Loading command modules..."
        "[  OK  ] Starting session logger..."
        "[  OK  ] All systems nominal."
    )
    for line in "${BOOT_LINES[@]}"; do
        echo -e "${GREEN}$line${RESET}"
        sleep 1
    done
    echo -e "$RESET"
    sleep 0.5
}

# ---- FIRST TIME SETUP ----
if [ ! -f "$CRED_FILE" ]; then
    clear
    print_big_banner
    print_login_subtitle
    echo ""
    echo -e "${BLUE}          FIRST TIME SETUP - CREATE YOUR LOGIN${RESET}"
    echo ""
    read -p "$(echo -e ${GREEN}Set your username: ${RESET})" NEW_USER
    read -s -p "$(echo -e ${GREEN}Set your password: ${RESET})" NEW_PASS
    echo ""
    HASHED=$(echo -n "$NEW_PASS" | sha256sum | awk '{print $1}')
    echo "$NEW_USER" > "$CRED_FILE"
    echo "$HASHED" >> "$CRED_FILE"
    chmod 600 "$CRED_FILE"
    echo -e "${GREEN}[+] Login created! Restart Termux to see the full experience.${RESET}"
    sleep 1.5
fi

# ---- NORMAL LOGIN ----
STORED_USER=$(sed -n '1p' "$CRED_FILE")
STORED_HASH=$(sed -n '2p' "$CRED_FILE")
MAX_TRIES=3
TRY=0
LOGIN_OK=0

while [ $TRY -lt $MAX_TRIES ]; do
    clear
    print_big_banner
    print_login_subtitle
    echo ""
    read -p "$(echo -e ${GREEN}Username: ${RESET})" INPUT_USER
    read -s -p "$(echo -e ${GREEN}Password: ${RESET})" INPUT_PASS
    echo ""
    INPUT_HASH=$(echo -n "$INPUT_PASS" | sha256sum | awk '{print $1}')

    if [ "$INPUT_USER" == "$STORED_USER" ] && [ "$INPUT_HASH" == "$STORED_HASH" ]; then
        LOGIN_OK=1
        break
    else
        TRY=$((TRY+1))
        echo -e "${RED}[-] Wrong credentials. Attempts left: $((MAX_TRIES-TRY))${RESET}"
        sleep 1.2
    fi
done

if [ $LOGIN_OK -eq 1 ]; then
    boot_sequence
else
    echo -e "${RED}[-] Too many failed attempts. Exiting.${RESET}"
    sleep 1
    exit 1
fi
