#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  TEAMVB LOGIN SCREEN - fully self-contained
# ============================================

THEME_DIR="$HOME/.termux-theme"
CRED_FILE="$THEME_DIR/.creds"
R='\e[1;31m'   # Red
B='\e[1;34m'   # Blue
G='\e[1;32m'   # Green
Y='\e[1;33m'   # Yellow
X='\e[0m'      # Reset

print_big_banner() {
    echo -e "$G"
    echo "  ████████╗███████╗ █████╗ ███╗   ███╗"
    echo "     ██╔══╝██╔════╝██╔══██╗████╗ ████║"
    echo "     ██║   █████╗  ███████║██╔████╔██║"
    echo "     ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║"
    echo "     ██║   ███████╗██║  ██║██║ ╚═╝ ██║"
    echo "     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝"
    echo ""
    echo "        ██╗   ██╗██████╗ "
    echo "        ██║   ██║██╔══██╗"
    echo "        ██║   ██║██████╔╝"
    echo "        ╚██╗ ██╔╝██╔══██╗"
    echo "         ╚████╔╝ ██████╔╝"
    echo "          ╚═══╝  ╚═════╝ "
    echo -e "$X"
}

print_subtitle() {
    echo -e "${R}╔══════════════════════════════════════╗${X}"
    echo -e "${B}║      TEAMVB  AGENT  LOGIN  PANEL     ║${X}"
    echo -e "${R}╚══════════════════════════════════════╝${X}"
    echo ""
}

do_hash() {
    # sha256sum with fallback to openssl
    if command -v sha256sum >/dev/null 2>&1; then
        echo -n "$1" | sha256sum | awk '{print $1}'
    else
        echo -n "$1" | openssl sha256 | awk '{print $2}'
    fi
}

boot_sequence() {
    clear
    echo -e "$G"
    if command -v termux-tts-speak >/dev/null 2>&1; then
        termux-tts-speak "Welcome back TEAMVB servers, I hope you are fine" >/dev/null 2>&1 &
    else
        echo -e "${Y}[!] Install 'Termux:API' app from Play Store for voice.${X}"
        echo ""
    fi
    LINES=(
        "[  OK  ] Initializing TEAMVB secure shell..."
        "[  OK  ] Mounting encrypted filesystem..."
        "[  OK  ] Loading network interfaces..."
        "[  OK  ] Establishing secure tunnel..."
        "[  OK  ] Verifying agent credentials..."
        "[  OK  ] Syncing team keys..."
        "[  OK  ] Checking server integrity..."
        "[  OK  ] Loading command modules..."
        "[  OK  ] Starting session logger..."
        "[  OK  ] All systems nominal. Welcome Agent!"
    )
    for line in "${LINES[@]}"; do
        echo -e "${G}$line${X}"
        sleep 1
    done
    echo ""
    sleep 0.5
}

# ────────────────────────────────────────────
#  FIRST TIME SETUP
# ────────────────────────────────────────────
if [ ! -f "$CRED_FILE" ]; then
    clear
    print_big_banner
    print_subtitle
    echo -e "${Y}  ★  FIRST TIME SETUP — Create your login  ★${X}"
    echo ""
    while true; do
        read -p "$(echo -e ${G}  Set Username: ${X})" NEW_USER
        [ -n "$NEW_USER" ] && break
        echo -e "${R}  Username cannot be empty.${X}"
    done
    while true; do
        read -s -p "$(echo -e ${G}  Set Password: ${X})" NEW_PASS
        echo ""
        [ -n "$NEW_PASS" ] && break
        echo -e "${R}  Password cannot be empty.${X}"
    done
    read -s -p "$(echo -e ${G}  Confirm Password: ${X})" CONFIRM_PASS
    echo ""
    if [ "$NEW_PASS" != "$CONFIRM_PASS" ]; then
        echo -e "${R}  Passwords do not match! Run again.${X}"
        sleep 2
        exit 1
    fi
    HASHED=$(do_hash "$NEW_PASS")
    echo "$NEW_USER" > "$CRED_FILE"
    echo "$HASHED"   >> "$CRED_FILE"
    chmod 600 "$CRED_FILE"
    echo ""
    echo -e "${G}  [+] Login created for: $NEW_USER${X}"
    echo -e "${G}  [+] Close and reopen Termux to login.${X}"
    sleep 2
    exit 0
fi

# ────────────────────────────────────────────
#  NORMAL LOGIN
# ────────────────────────────────────────────
STORED_USER=$(sed -n '1p' "$CRED_FILE")
STORED_HASH=$(sed -n '2p' "$CRED_FILE")
MAX_TRIES=3
TRY=0
LOGIN_OK=0

while [ $TRY -lt $MAX_TRIES ]; do
    clear
    print_big_banner
    print_subtitle
    read -p "$(echo -e ${G}  Username: ${X})" INPUT_USER
    read -s -p "$(echo -e ${G}  Password: ${X})" INPUT_PASS
    echo ""
    INPUT_HASH=$(do_hash "$INPUT_PASS")

    if [ "$INPUT_USER" = "$STORED_USER" ] && [ "$INPUT_HASH" = "$STORED_HASH" ]; then
        LOGIN_OK=1
        break
    else
        TRY=$((TRY+1))
        echo ""
        echo -e "${R}  [-] Wrong credentials. Attempts left: $((MAX_TRIES-TRY))${X}"
        sleep 1.5
    fi
done

if [ $LOGIN_OK -eq 1 ]; then
    boot_sequence
else
    clear
    echo -e "${R}  [-] Too many failed attempts.${X}"
    echo -e "${Y}  To reset login: rm ~/.termux-theme/.creds${X}"
    sleep 2
    exit 1
fi
