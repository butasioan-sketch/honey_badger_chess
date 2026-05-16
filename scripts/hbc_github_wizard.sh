#!/bin/bash
set -e

echo "===== HBC GITHUB WIZARD ====="
echo ""

read -p "GitHub Username: " GITHUB_USER
read -p "Repository Name [honey_badger_chess]: " REPO

REPO=${REPO:-honey_badger_chess}

echo ""
echo "1) Öffne jetzt im Browser:"
echo "https://github.com/new"
echo ""
echo "2) Repository Name:"
echo "$REPO"
echo ""
echo "3) Wichtig:"
echo "   - PRIVATE auswählen"
echo "   - NICHT README hinzufügen"
echo "   - NICHT .gitignore hinzufügen"
echo ""
read -p "Wenn das Repo erstellt ist: ENTER drücken"

git remote remove origin 2>/dev/null || true

git remote add origin git@github.com:$GITHUB_USER/$REPO.git

git branch -M main

echo ""
echo "Teste GitHub Verbindung..."

ssh -T git@github.com || true

echo ""
echo "Push läuft..."

git push -u origin main --tags

echo ""
echo "FERTIG."
echo "GitHub verbunden:"
echo "https://github.com/$GITHUB_USER/$REPO"
