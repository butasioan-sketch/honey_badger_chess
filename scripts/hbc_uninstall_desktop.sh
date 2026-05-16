#!/bin/bash
set -e

DESKTOP_FILE="$HOME/.local/share/applications/honey_badger_chess.desktop"

echo "===== UNINSTALL HONEY BADGER CHESS DESKTOP ====="

rm -f "$DESKTOP_FILE"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "Desktop-Eintrag entfernt."
