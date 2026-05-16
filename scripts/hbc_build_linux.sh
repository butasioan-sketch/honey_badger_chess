#!/bin/bash
set -e

echo "===== HBC LINUX BUILD ====="

flutter clean
flutter pub get

echo ""
echo "Analyze..."
flutter analyze

echo ""
echo "Release Build..."
flutter build linux --release

echo ""
echo "Build fertig:"
echo "build/linux/x64/release/bundle/"
