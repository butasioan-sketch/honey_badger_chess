#!/bin/bash
set -e

echo "===== HBC ANDROID SETUP ====="

sudo apt update

echo ""
echo "Installiere Android Abhängigkeiten..."
sudo apt install -y \
  openjdk-17-jdk \
  unzip \
  zip \
  curl \
  wget \
  adb

echo ""
echo "Java Version:"
java -version

mkdir -p "$HOME/Android"

cd "$HOME/Android"

if [ ! -d "cmdline-tools" ]; then
  echo ""
  echo "Lade Android Command Line Tools..."
  
  wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -O cmdline-tools.zip
  
  unzip cmdline-tools.zip
  
  mkdir -p cmdline-tools/latest
  
  mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
fi

echo ""
echo "ANDROID_HOME setzen..."

grep -q "ANDROID_HOME" ~/.bashrc || cat >> ~/.bashrc <<'ENV'

export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
ENV

export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

echo ""
echo "SDK installieren..."

yes | sdkmanager --licenses

sdkmanager \
  "platform-tools" \
  "platforms;android-35" \
  "build-tools;35.0.0"

echo ""
echo "Flutter Android aktivieren..."

flutter config --android-sdk "$ANDROID_HOME"

flutter doctor

echo ""
echo "ANDROID SETUP FERTIG."
