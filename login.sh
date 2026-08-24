#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  LOCAL LOGIN SCREEN (per-user, stored locally)
#  Not a real security system — just a personal
#  lock/greeting screen for your own terminal.
# ============================================

CRED_FILE="$HOME/.termux-theme/.creds"
GREEN='\e[1;32m'
RESET='\e[0m'

# Green-on-black hacker style for the whole session
echo -e "\e[1;32m\e[40m"

# ---- FIRST TIME SETUP: user creates their own username/password ----
if [ ! -f "$CRED_FILE" ]; then
    clear
    echo -e "${GREEN}=================================================="
    echo "        FIRST TIME SETUP - CREATE YOUR LOGIN"
    echo -e "==================================================${RESET}"
    read -p "$(echo -e ${GREEN}Set your username: ${RESET})" NEW_USER
    read -s -p "$(echo -e ${GREEN}Set your password: ${RESET})" NEW_PASS
    echo ""
    # store username plain, password hashed (sha256)
    HASHED_PASS=$(echo -n "$NEW_PASS" | sha256sum | awk '{print $1}')
    echo "$NEW_USER" > "$CRED_FILE"
    echo "$HASHED_PASS" >> "$CRED_FILE"
    chmod 600 "$CRED_FILE"
    echo -e "${GREEN}[+] Login created! It will be asked every time Termux restarts.${RESET}"
    sleep 1
fi

# ---- NORMAL LOGIN CHECK (every restart) ----
STORED_USER=$(sed -n '1p' "$CRED_FILE")
STORED_HASH=$(sed -n '2p' "$CRED_FILE")

MAX_TRIES=3
TRY=0
while [ $TRY -lt $MAX_TRIES ]; do
    clear
    echo -e "${GREEN}=================================================="
    echo "                 TEAMVB LOGIN"
    echo -e "==================================================${RESET}"
    read -p "$(echo -e ${GREEN}Username: ${RESET})" INPUT_USER
    read -s -p "$(echo -e ${GREEN}Password: ${RESET})" INPUT_PASS
    echo ""
    INPUT_HASH=$(echo -n "$INPUT_PASS" | sha256sum | awk '{print $1}')

    if [ "$INPUT_USER" == "$STORED_USER" ] && [ "$INPUT_HASH" == "$STORED_HASH" ]; then
        clear
        echo -e "${GREEN}[+] Login successful. Welcome back, $INPUT_USER!${RESET}"
        sleep 1
        break
    else
        TRY=$((TRY+1))
        echo -e "${GREEN}[-] Wrong username/password. Attempts left: $((MAX_TRIES-TRY))${RESET}"
        sleep 1
    fi

    if [ $TRY -eq $MAX_TRIES ]; then
        echo -e "${GREEN}[-] Too many failed attempts. Exiting Termux session.${RESET}"
        exit 1
    fi
done
