#!/bin/bash
set -e

APP="./build/linux/x64/release/bundle/honey_badger_chess"

if [ ! -f "$APP" ]; then
  echo "Release-App nicht gefunden. Baue zuerst..."
  bash scripts/hbc_build_linux.sh
fi

echo "Starte Honey Badger Chess Release..."
"$APP"
