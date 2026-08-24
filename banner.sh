#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  TEAM BANNER + VOICE WELCOME
#  Same for all users who install this theme
# ============================================

TEAM_NAME="TEAMVB"
VOICE_MESSAGE="Welcome back TEAMVB servers, I hope you are fine"

GREEN='\e[1;32m'
RESET='\e[0m'

clear

# ---- ASCII Art Banner (pure green, hacker style) ----
if command -v figlet >/dev/null; then
    echo -e "$GREEN"
    figlet -f slant "$TEAM_NAME"
    echo -e "$RESET"
fi

# ---- Tagline ----
echo -e "${GREEN}     >> Authorized Access Only :: System Ready <<${RESET}"

echo -e "$GREEN"
date
echo -e "$RESET"

# ---- Voice Welcome (needs Termux:API app installed) ----
if command -v termux-tts-speak >/dev/null; then
    termux-tts-speak "$VOICE_MESSAGE" &
fi
