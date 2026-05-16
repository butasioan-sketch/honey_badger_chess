#!/bin/bash
set -e

echo "===== HBC AUTO PUSH ====="
echo ""

read -p "Commit Message: " MSG

if [ -z "$MSG" ]; then
  MSG="update"
fi

git add .

git commit -m "$MSG" || true

git push

echo ""
echo "Push abgeschlossen."
