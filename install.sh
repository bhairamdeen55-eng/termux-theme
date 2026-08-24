#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  TEAMVB THEME INSTALLER
# ============================================

set -e
THEME_DIR="$HOME/.termux-theme"
TERMUX_CFG="$HOME/.termux"

echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║    Installing TEAMVB Termux Theme     ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""

# 1. Packages
pkg update -y
pkg install -y figlet toilet termux-api python

# 2. Create theme directory and copy files
mkdir -p "$THEME_DIR"
cp ./login.sh     "$THEME_DIR/login.sh"
cp ./banner.sh    "$THEME_DIR/banner.sh"
cp ./colors.sh    "$THEME_DIR/colors.sh"

# Copy voice.mp3 if it exists in the repo
if [ -f "./voice.mp3" ]; then
    cp ./voice.mp3 "$THEME_DIR/voice.mp3"
    echo "  [+] voice.mp3 copied to theme folder"
else
    echo "  [!] voice.mp3 not found in repo — TTS fallback will be used"
fi

chmod +x "$THEME_DIR/login.sh" "$THEME_DIR/banner.sh" "$THEME_DIR/colors.sh"

# 3. Set default terminal color to GREEN (fixes white text in all commands)
mkdir -p "$TERMUX_CFG"
cat > "$TERMUX_CFG/colors.properties" << 'EOF'
background=#000000
foreground=#00ff00
color0=#000000
color1=#ff3333
color2=#00ff00
color3=#ffff00
color4=#3399ff
color5=#cc44ff
color6=#00ffff
color7=#00ff00
color8=#555555
color9=#ff6666
color10=#66ff66
color11=#ffff66
color12=#66aaff
color13=#dd88ff
color14=#66ffff
color15=#00ff00
EOF
echo "  [+] Terminal color set to green (all output will be green now)"

# Reload terminal colors
if command -v termux-reload-settings >/dev/null 2>&1; then
    termux-reload-settings
fi

# 4. Hook into .bashrc
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
echo "  [+] Installation complete!"
echo "  [+] Close and reopen Termux to see TEAMVB theme."
echo ""
