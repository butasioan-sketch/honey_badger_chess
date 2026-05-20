import 'package:flutter/material.dart';

import 'piece_render_mode.dart';

class PieceRenderer extends StatelessWidget {
  final String piece;
  final double size;
  final bool white;
  final bool active;

  const PieceRenderer({
    super.key,
    required this.piece,
    required this.size,
    required this.white,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    switch (PieceRenderConfig.mode) {
      case PieceRenderMode.model3d:
        return _Model3DPlaceholder(
          piece: piece,
          size: size,
          white: white,
          active: active,
        );

      case PieceRenderMode.unicode3d:
        return _Unicode3DPiece(
          piece: piece,
          size: size,
          white: white,
          active: active,
        );
    }
  }
}

class _Model3DPlaceholder extends StatelessWidget {
  final String piece;
  final double size;
  final bool white;
  final bool active;

  const _Model3DPlaceholder({
    required this.piece,
    required this.size,
    required this.white,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _Unicode3DPiece(
          piece: piece,
          size: size,
          white: white,
          active: active,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '3D',
              style: TextStyle(
                color: Colors.black,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Unicode3DPiece extends StatelessWidget {
  final String piece;
  final double size;
  final bool white;
  final bool active;

  const _Unicode3DPiece({
    required this.piece,
    required this.size,
    required this.white,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = white
        ? const Color(0xFFF2E6C9)
        : const Color(0xFF080808);

    final sideColor = white
        ? const Color(0xFFB39148)
        : const Color(0xFF3B2608);

    final edgeColor = white
        ? const Color(0xFFFFD76A)
        : const Color(0xFFB08A2E);

    return SizedBox(
      width: size * 1.25,
      height: size * 1.35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: size * 0.04,
            child: Container(
              width: size * 0.82,
              height: size * 0.18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.black.withValues(alpha: active ? 0.42 : 0.30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: active ? 18 : 12,
                    spreadRadius: active ? 2 : 1,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: size * 0.14,
            child: Container(
              width: size * 0.70,
              height: size * 0.18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    edgeColor.withValues(alpha: 0.90),
                    sideColor,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
                border: Border.all(
                  color: edgeColor.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
            ),
          ),

          for (int i = 10; i >= 1; i--)
            Transform.translate(
              offset: Offset(i * size * 0.012, i * size * 0.018),
              child: Text(
                piece,
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w900,
                  color: sideColor.withValues(alpha: 0.55),
                ),
              ),
            ),

          Transform.translate(
            offset: Offset(size * 0.035, size * 0.065),
            child: Text(
              piece,
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w900,
                color: Colors.black.withValues(alpha: 0.35),
              ),
            ),
          ),

          Text(
            piece,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w900,
              color: mainColor,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.90),
                  blurRadius: active ? 12 : 8,
                  offset: Offset(size * 0.025, size * 0.045),
                ),
                Shadow(
                  color: edgeColor.withValues(alpha: active ? 0.85 : 0.42),
                  blurRadius: active ? 18 : 10,
                ),
                if (white)
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.65),
                    blurRadius: 6,
                    offset: Offset(-size * 0.018, -size * 0.018),
                  ),
              ],
            ),
          ),

          Positioned(
            top: size * 0.10,
            left: size * 0.24,
            child: Container(
              width: size * 0.18,
              height: size * 0.42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: white ? 0.34 : 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
