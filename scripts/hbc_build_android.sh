#!/bin/bash
set -e

echo "===== HBC ANDROID APK BUILD ====="

export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

echo ""
echo "Flutter Doctor:"
flutter doctor

echo ""
echo "Clean + Pub Get:"
flutter clean
flutter pub get

echo ""
echo "Analyze:"
flutter analyze

echo ""
echo "Build APK Release:"
flutter build apk --release

echo ""
echo "APK fertig:"
echo "build/app/outputs/flutter-apk/app-release.apk"
