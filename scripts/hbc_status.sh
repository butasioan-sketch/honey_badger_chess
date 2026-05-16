#!/bin/bash
set -e

echo "===== HBC STATUS ====="
echo ""

echo "Projekt:"
pwd

echo ""
echo "Flutter:"
flutter --version | head -n 3

echo ""
echo "Dateien:"
find lib -maxdepth 3 -type f | sort

echo ""
echo "Assets:"
find assets -maxdepth 3 -type f | sort || true

echo ""
echo "Backups:"
ls -dt .hbc_backups/* 2>/dev/null | head -n 5 || echo "Keine Backups"

echo ""
echo "Analyze:"
flutter analyze
