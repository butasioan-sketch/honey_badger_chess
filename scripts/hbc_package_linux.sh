#!/bin/bash
set -e

APP_NAME="honey_badger_chess"
STAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUT_DIR="dist"
ZIP_NAME="$OUT_DIR/${APP_NAME}_linux_$STAMP.zip"

echo "===== HBC PACKAGE LINUX ====="

mkdir -p "$OUT_DIR"

bash scripts/hbc_build_linux.sh

echo ""
echo "Erstelle ZIP..."
cd build/linux/x64/release
zip -r "../../../..//$ZIP_NAME" bundle

echo ""
echo "Package fertig:"
echo "$ZIP_NAME"
