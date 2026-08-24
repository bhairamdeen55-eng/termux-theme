#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  BOOT SEQUENCE (~10 sec) + VOICE WELCOME
#  Runs right after successful login
# ============================================

GREEN='\e[1;32m'
RED='\e[1;31m'
RESET='\e[0m'
VOICE_MESSAGE="Welcome back TEAMVB servers, I hope you are fine"

clear
echo -e "$GREEN"

# ---- Start voice in background so it plays WHILE logs are scrolling ----
if command -v termux-tts-speak >/dev/null 2>&1; then
    termux-tts-speak "$VOICE_MESSAGE" >/dev/null 2>&1 &
else
    echo -e "${RED}[!] Voice disabled: install the 'Termux:API' app (Play Store / F-Droid) to enable it.${RESET}"
fi

BOOT_LINES=(
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

TOTAL_TIME=10
STEP=$(awk "BEGIN{printf \"%.2f\", $TOTAL_TIME/${#BOOT_LINES[@]}}")

for line in "${BOOT_LINES[@]}"; do
    echo -e "$line"
    sleep "$STEP"
done

echo -e "$RESET"
sleep 0.5
