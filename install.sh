#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  TERMUX CUSTOM THEME INSTALLER
#  Team Banner + Voice Welcome + Login + Colors
# ============================================

set -e

TEAM_NAME="TEAMVB"
VOICE_MESSAGE="Welcome back TEAMVB servers, I hope you are fine"
THEME_DIR="$HOME/.termux-theme"

echo ""
echo "=================================================="
echo "   Installing $TEAM_NAME Termux Theme..."
echo "=================================================="
echo ""

# 1. Update & install required packages
pkg update -y
pkg install -y figlet toilet termux-api python

# grc (command output colorizer) - optional, installed via pip since it's
# not in the default Termux repo
pip install grc 2>/dev/null || echo "[!] grc install skipped (optional, not critical)"

# 2. Setup Termux:API (voice needs the Termux:API app installed from Play/F-Droid too)
echo "[*] Make sure you also install the 'Termux:API' app from Play Store / F-Droid"

# 3. Create theme directory
mkdir -p "$THEME_DIR"
cp -r ./assets/* "$THEME_DIR/" 2>/dev/null || true
cp ./banner.sh "$THEME_DIR/banner.sh"
cp ./login.sh "$THEME_DIR/login.sh"
cp ./colors.sh "$THEME_DIR/colors.sh"
chmod +x "$THEME_DIR/banner.sh" "$THEME_DIR/login.sh" "$THEME_DIR/colors.sh"

# 4. Hook into .bashrc so it runs on every Termux launch/restart
BASHRC="$HOME/.bashrc"
touch "$BASHRC"

if ! grep -q "termux-theme" "$BASHRC"; then
cat >> "$BASHRC" << 'EOF'

# ==== termux-theme auto-start ====
bash "$HOME/.termux-theme/login.sh"
bash "$HOME/.termux-theme/banner.sh"
source "$HOME/.termux-theme/colors.sh"
# ==================================
EOF
fi

echo ""
echo "[+] Installation complete!"
echo "[+] Restart Termux now to see your theme in action."
echo ""
