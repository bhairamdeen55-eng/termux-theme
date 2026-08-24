#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  FINAL BANNER (shown after boot sequence, before shell)
# ============================================

THEME_DIR="$HOME/.termux-theme"
source "$THEME_DIR/branding.sh"

clear
print_big_banner
echo -e "${GREEN}     >> Authorized Access Only :: System Ready <<${RESET}"
echo -e "${GREEN}"
date
echo -e "${RESET}"
