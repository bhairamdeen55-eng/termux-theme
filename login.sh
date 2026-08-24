#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  LOCAL LOGIN SCREEN (per-user, stored locally)
# ============================================

THEME_DIR="$HOME/.termux-theme"
CRED_FILE="$THEME_DIR/.creds"
source "$THEME_DIR/branding.sh"

# ---- FIRST TIME SETUP: user creates their own username/password ----
if [ ! -f "$CRED_FILE" ]; then
    clear
    print_big_banner
    print_login_subtitle
    echo ""
    echo -e "${GREEN}          FIRST TIME SETUP - CREATE YOUR LOGIN${RESET}"
    echo ""
    read -p "$(echo -e ${GREEN}Set your username: ${RESET})" NEW_USER
    read -s -p "$(echo -e ${GREEN}Set your password: ${RESET})" NEW_PASS
    echo ""
    HASHED_PASS=$(echo -n "$NEW_PASS" | sha256sum | awk '{print $1}')
    echo "$NEW_USER" > "$CRED_FILE"
    echo "$HASHED_PASS" >> "$CRED_FILE"
    chmod 600 "$CRED_FILE"
    echo -e "${GREEN}[+] Login created! It will be asked every time Termux restarts.${RESET}"
    sleep 1.5
fi

# ---- NORMAL LOGIN CHECK (every restart) ----
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
        echo -e "${RED}[-] Wrong username/password. Attempts left: $((MAX_TRIES-TRY))${RESET}"
        sleep 1.2
    fi
done

if [ $LOGIN_OK -eq 1 ]; then
    # ---- Boot sequence (~10 sec) + voice plays during it ----
    bash "$THEME_DIR/bootlogs.sh"
else
    echo -e "${RED}[-] Too many failed attempts. Exiting Termux session.${RESET}"
    sleep 1
    exit 1
fi
