#!/bin/bash

echo "===== HBC GIT REMOTE SETUP ====="
echo ""

read -p "GitHub Username: " USER
read -p "Repository Name [honey_badger_chess]: " REPO

REPO=${REPO:-honey_badger_chess}

git remote remove origin 2>/dev/null || true

git remote add origin git@github.com:$USER/$REPO.git

echo ""
echo "Remote gesetzt:"
git remote -v

echo ""
echo "Nächste Schritte:"
echo "1) Repository auf GitHub erstellen"
echo "2) Dann:"
echo "   git push -u origin main --tags"
