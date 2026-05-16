#!/bin/bash
set -e

echo "===== HONEY BADGER CHESS DOCTOR ====="
echo ""

echo "1) Ordner:"
pwd

echo ""
echo "2) Flutter:"
flutter --version | head -n 3

echo ""
echo "3) Projektdateien:"
find lib -maxdepth 3 -type f | sort

echo ""
echo "4) Assets:"
find assets -maxdepth 3 -type f | sort || true

echo ""
echo "5) Git Snapshot:"
git status --short || true

echo ""
echo "6) Analyze:"
flutter analyze

echo ""
echo "7) Fertig."
