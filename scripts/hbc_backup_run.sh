#!/bin/bash
set -e

STAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR=".hbc_backups/$STAMP"

echo "===== HBC BACKUP + RUN ====="
echo "Backup: $BACKUP_DIR"

mkdir -p "$BACKUP_DIR"

cp -r lib "$BACKUP_DIR/lib"
cp -r assets "$BACKUP_DIR/assets" 2>/dev/null || true
cp pubspec.yaml "$BACKUP_DIR/pubspec.yaml"

echo "Backup erstellt."

echo "Flutter analyze..."
flutter analyze

echo "Starte App..."
flutter run -d linux
