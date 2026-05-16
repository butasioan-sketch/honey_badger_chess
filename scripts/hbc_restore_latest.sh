#!/bin/bash
set -e

LATEST=$(ls -dt .hbc_backups/* 2>/dev/null | head -n 1)

if [ -z "$LATEST" ]; then
  echo "Kein Backup gefunden."
  exit 1
fi

echo "Restore von: $LATEST"

cp -r "$LATEST/lib" .
cp -r "$LATEST/assets" . 2>/dev/null || true
cp "$LATEST/pubspec.yaml" .

echo "Restore fertig."
flutter analyze
