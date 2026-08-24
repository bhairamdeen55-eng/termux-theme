#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  FINAL BANNER (shown after boot, before shell)
#  Self-contained — no external dependencies
# ============================================

GREEN='\e[1;32m'
RED='\e[1;31m'
BLUE='\e[1;34m'
RESET='\e[0m'

clear
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
echo -e "${RESET}"
echo -e "${RED}================================================${RESET}"
echo -e "${BLUE}     >> Authorized Access Only :: System Ready <<${RESET}"
echo -e "${RED}================================================${RESET}"
echo -e "${GREEN}"
date
echo -e "${RESET}"
