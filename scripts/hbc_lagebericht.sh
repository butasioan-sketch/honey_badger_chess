#!/bin/bash

STAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT="reports/lagebericht_$STAMP.txt"

{
echo "===== HONEY BADGER CHESS LAGEBERICHT ====="
echo "Zeit: $(date)"
echo ""

echo "1) ORDNER"
pwd
echo ""

echo "2) FLUTTER VERSION"
flutter --version | head -n 5
echo ""

echo "3) GIT STATUS"
git status --short 2>&1
echo ""

echo "4) GIT BRANCH / REMOTE"
git branch 2>&1
git remote -v 2>&1
echo ""

echo "5) DATEIEN LIB"
find lib -maxdepth 4 -type f | sort
echo ""

echo "6) ASSETS"
find assets -maxdepth 5 -type f | sort 2>/dev/null
echo ""

echo "7) SCRIPTS"
find scripts -maxdepth 2 -type f | sort
echo ""

echo "8) PUBSPEC ASSETS"
grep -n "assets/\\|name:\\|flutter:" pubspec.yaml
echo ""

echo "9) WICHTIGE IMPORTS"
echo "--- main.dart ---"
sed -n '1,80p' lib/main.dart
echo ""
echo "--- dashboard imports ---"
sed -n '1,40p' lib/features/dashboard/dashboard_screen.dart
echo ""
echo "--- board imports ---"
sed -n '1,40p' lib/widgets/chess_board_widget.dart
echo ""

echo "10) CONTROL CHECK"
grep -n "PLAY\\|STOP\\|TILT\\|CAM\\|VISUAL CIPHER" lib/widgets/chess_board_widget.dart 2>&1
echo ""

echo "11) RENDERING CHECK"
find lib/core/rendering -maxdepth 2 -type f -print -exec sed -n '1,40p' {} \; 2>&1
echo ""

echo "12) NETWORK CHECK"
find lib/core/network -maxdepth 2 -type f -print -exec sed -n '1,50p' {} \; 2>&1
echo ""

echo "13) FLUTTER ANALYZE"
flutter analyze 2>&1

echo ""
echo "===== ENDE LAGEBERICHT ====="
} | tee "$REPORT"

echo ""
echo "Gespeichert unter:"
echo "$REPORT"
