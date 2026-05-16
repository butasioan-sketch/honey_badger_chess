#!/bin/bash
set -e

VERSION=$(date +"0.1.%Y%m%d_%H%M")
STAMP=$(date +"%Y-%m-%d_%H-%M-%S")

echo "===== HBC RELEASE ====="
echo "Version: $VERSION"

mkdir -p dist
mkdir -p release_notes

bash scripts/hbc_package_linux.sh

LATEST_ZIP=$(ls -t dist/*.zip | head -n 1)

cat > "release_notes/release_$STAMP.md" <<NOTE
# Honey Badger Chess Release

Version: $VERSION
Date: $(date)

## Features
- 3D / 360 Chess Board
- Visual Cipher Playback
- Offline Cipher V3
- Noise Moves
- Encrypted Sessions
- Burn / TTL
- Responsive Desktop + Mobile Layout
- Camera Presets
- AutoCam Playback
- Glow Visualizer
- Linux Release Build

## Package
$LATEST_ZIP
NOTE

echo ""
echo "Release erstellt:"
echo "$LATEST_ZIP"

echo ""
echo "Release Notes:"
echo "release_notes/release_$STAMP.md"
