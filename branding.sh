#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  SHARED BRANDING (big banner + colors)
#  Sourced by login.sh and banner.sh
# ============================================

RED='\e[1;31m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
RESET='\e[0m'

# Print a BIG "TEAMVB" banner (tries toilet big font first, then figlet,
# then a plain fallback so it never just silently disappears)
print_big_banner() {
    echo -e "$GREEN"
    if command -v toilet >/dev/null 2>&1; then
        toilet -f pagga -F metal "TEAMVB" 2>/dev/null || toilet -f big "TEAMVB"
    elif command -v figlet >/dev/null 2>&1; then
        figlet -f big "TEAMVB"
        figlet -f big "TEAMVB"   # printed twice = taller / more visible on mobile
    else
        echo "########################################"
        echo "#               T E A M V B           #"
        echo "########################################"
    fi
    echo -e "$RESET"
}

print_login_subtitle() {
    echo -e "${RED}================================================${RESET}"
    echo -e "${BLUE}              TEAMVB AGENT LOGIN PANEL${RESET}"
    echo -e "${RED}================================================${RESET}"
}
