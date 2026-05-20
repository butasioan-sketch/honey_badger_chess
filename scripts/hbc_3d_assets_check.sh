#!/bin/bash
set -e

echo "===== HBC 3D ASSET CHECK ====="
echo ""

echo "3D Ordner:"
find assets/3d -maxdepth 3 -type d | sort

echo ""
echo "3D Dateien:"
find assets/3d -maxdepth 4 -type f | sort || true

echo ""
echo "Erwartete Figuren:"
echo "assets/3d/pieces/king.glb"
echo "assets/3d/pieces/queen.glb"
echo "assets/3d/pieces/bishop.glb"
echo "assets/3d/pieces/knight.glb"
echo "assets/3d/pieces/rook.glb"
echo "assets/3d/pieces/pawn.glb"

echo ""
echo "Pubspec 3D Assets:"
grep -n "assets/3d" pubspec.yaml || true

echo ""
echo "Fertig."
