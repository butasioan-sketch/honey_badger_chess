#!/bin/bash
set -e

APP_DIR="$HOME/honey_badger_chess"
DESKTOP_FILE="$HOME/.local/share/applications/honey_badger_chess.desktop"

echo "===== INSTALL HONEY BADGER CHESS DESKTOP ====="

bash "$APP_DIR/scripts/hbc_build_linux.sh"

mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_FILE" <<DESKTOP
[Desktop Entry]
Version=1.0
Type=Application
Name=Honey Badger Chess
Comment=3D Visual Cipher Chess System
Exec=$APP_DIR/build/linux/x64/release/bundle/honey_badger_chess
Icon=$APP_DIR/assets/logos/honey_badger_logo.png
Terminal=false
Categories=Game;Utility;Security;
StartupNotify=true
DESKTOP

chmod +x "$DESKTOP_FILE"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "Installiert."
echo "Du findest Honey Badger Chess jetzt im App-Menü."
