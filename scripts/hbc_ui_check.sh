#!/bin/bash
set -e

echo "===== HBC UI CHECK ====="
echo ""

echo "Suche wichtige Board Controls:"
grep -n "PLAY" lib/widgets/chess_board_widget.dart
grep -n "STOP" lib/widgets/chess_board_widget.dart
grep -n "TILT" lib/widgets/chess_board_widget.dart
grep -n "CAM" lib/widgets/chess_board_widget.dart
grep -n "VISUAL CIPHER READY" lib/widgets/chess_board_widget.dart

echo ""
echo "Analyze:"
flutter analyze

echo ""
echo "UI Check fertig."
