import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ChessBoardWidget extends StatefulWidget {
  final List<String> visualMoves;

  const ChessBoardWidget({
    super.key,
    this.visualMoves = const [],
  });

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  double rotation = 0;
  double tilt = -0.36;
  bool whiteView = true;
  bool showPieces = true;
  bool showCoords = true;
  int colorProfile = 0;
  int cameraPreset = 0;

  int playbackIndex = -1;
  int playbackSpeedMs = 850;
  Timer? playbackTimer;

  final Map<String, String> pieces = {
    'a8':'♜','b8':'♞','c8':'♝','d8':'♛','e8':'♚','f8':'♝','g8':'♞','h8':'♜',
    'a7':'♟','b7':'♟','c7':'♟','d7':'♟','e7':'♟','f7':'♟','g7':'♟','h7':'♟',
    'a2':'♙','b2':'♙','c2':'♙','d2':'♙','e2':'♙','f2':'♙','g2':'♙','h2':'♙',
    'a1':'♖','b1':'♘','c1':'♗','d1':'♕','e1':'♔','f1':'♗','g1':'♘','h1':'♖',
  };

  bool whitePiece(String? p) => ['♔','♕','♖','♗','♘','♙'].contains(p);

  void resetView() {
    playbackTimer?.cancel();
    setState(() {
      rotation = 0;
      tilt = -0.36;
      whiteView = true;
      cameraPreset = 0;
      playbackIndex = -1;
    });
  }

  void nextCameraPreset() {
    setState(() {
      cameraPreset = (cameraPreset + 1) % 4;

      if (cameraPreset == 0) {
        tilt = -0.36;
        rotation = 0;
      } else if (cameraPreset == 1) {
        tilt = -0.48;
        rotation = 0;
      } else if (cameraPreset == 2) {
        tilt = -0.30;
        rotation = pi / 8;
      } else {
        tilt = -0.52;
        rotation = -pi / 8;
      }
    });
  }

  void startPlayback() {
    if (widget.visualMoves.isEmpty) return;
    playbackTimer?.cancel();

    setState(() => playbackIndex = 0);

    playbackTimer = Timer.periodic(Duration(milliseconds: playbackSpeedMs), (timer) {
      if (playbackIndex >= widget.visualMoves.length - 1) {
        timer.cancel();

        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;

          setState(() {
            tilt = -0.36;
          });
        });

        return;
      }
      setState(() {
        playbackIndex++;

        final wave = (playbackIndex % 6);

        if (wave == 0) {
          rotation += pi / 48;
        } else if (wave == 1) {
          tilt -= 0.015;
        } else if (wave == 2) {
          rotation -= pi / 64;
        } else if (wave == 3) {
          tilt += 0.012;
        } else if (wave == 4) {
          rotation += pi / 80;
        } else {
          tilt -= 0.008;
        }
      });
    });
  }

  void stopPlayback() {
    playbackTimer?.cancel();
    setState(() => playbackIndex = -1);
  }

  @override
  void dispose() {
    playbackTimer?.cancel();
    super.dispose();
  }

  bool isVisualSquare(String square) {
    if (widget.visualMoves.isEmpty) return false;

    if (playbackIndex >= 0 && playbackIndex < widget.visualMoves.length) {
      return widget.visualMoves[playbackIndex].split('-').contains(square);
    }

    return widget.visualMoves.any((m) => m.split('-').contains(square));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final availableW = c.maxWidth;
        final availableH = c.maxHeight - 78;
        final boardSize = min(availableW * 0.99, availableH * 0.99);

        final matrix = Matrix4.identity()
          ..setEntry(3, 2, 0.00115)
          ..rotateX(tilt)
          ..rotateZ(rotation + (whiteView ? 0 : pi));

        return Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: boardSize,
                  height: boardSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: matrix.clone()
                          ..translateByDouble(0.0, boardSize * 0.035, 0.0, 1.0)
                          ..scaleByDouble(1.025, 1.025, 1.0, 1.0),
                        child: Container(
                          width: boardSize,
                          height: boardSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF7A5A16),
                                Color(0xFF191006),
                                Color(0xFF020202),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.88),
                                blurRadius: 50,
                                offset: const Offset(0, 26),
                              ),
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                                blurRadius: 38,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Transform(
                        alignment: Alignment.center,
                        transform: matrix,
                        child: Container(
                          width: boardSize,
                          height: boardSize,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFFD76A),
                                Color(0xFF2A1A05),
                                Color(0xFFD4AF37),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFFFFD76A),
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withValues(alpha: 0.22),
                                blurRadius: 28,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.75),
                                blurRadius: 32,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 64,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                              ),
                              itemBuilder: (context, index) {
                                final row = index ~/ 8;
                                final col = index % 8;
                                final square = '${String.fromCharCode(97 + col)}${8 - row}';
                                final light = (row + col).isEven;
                                final piece = pieces[square];
                                final visual = isVisualSquare(square);

                                final lightColors = colorProfile == 0
                                    ? [const Color(0xFFD8C59A), const Color(0xFF9E7A42)]
                                    : colorProfile == 1
                                        ? [const Color(0xFFE0D8C0), const Color(0xFF8B8F86)]
                                        : [const Color(0xFFD6B36A), const Color(0xFF6B4A12)];

                                final darkColors = colorProfile == 0
                                    ? [const Color(0xFF18263B), const Color(0xFF05080D)]
                                    : colorProfile == 1
                                        ? [const Color(0xFF101820), const Color(0xFF030405)]
                                        : [const Color(0xFF2B1607), const Color(0xFF050201)];

                                return AnimatedScale(
                                  duration: const Duration(milliseconds: 260),
                                  scale: visual ? 1.018 : 1.0,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    decoration: BoxDecoration(
                                      boxShadow: visual
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFD4AF37)
                                                    .withValues(alpha: 0.22),
                                                blurRadius: 8,
                                                spreadRadius: 0.4,
                                              ),
                                            ]
                                          : [],
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: visual
                                            ? [
                                                const Color(0xFFB08A2E),
                                                const Color(0xFF3E2D08),
                                              ]
                                            : light
                                                ? lightColors
                                                : darkColors,
                                      ),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: [
                                        if (showCoords)
                                          Positioned(
                                            top: 5,
                                            left: 6,
                                            child: Text(
                                              square,
                                              style: TextStyle(
                                                fontSize: boardSize / 24,
                                                fontWeight: FontWeight.w900,
                                                color: light
                                                    ? const Color(0xFF4C2D00)
                                                    : const Color(0xFFB08A2E),
                                                shadows: const [
                                                  Shadow(color: Colors.black, blurRadius: 2),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (showPieces && piece != null)
                                          Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Transform.translate(
                                                  offset: Offset(
                                                    visual ? 3 : 2,
                                                    visual ? 5 : 3,
                                                  ),
                                                  child: Text(
                                                    piece,
                                                    style: TextStyle(
                                                      fontSize: visual
                                                          ? boardSize / 8.6
                                                          : boardSize / 9.2,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.black.withValues(alpha: 0.38),
                                                    ),
                                                  ),
                                                ),
                                                _Piece3D(
                                                  piece: piece,
                                                  size: visual
                                                      ? boardSize / 8.6
                                                      : boardSize / 9.2,
                                                  white: whitePiece(piece),
                                                  active: visual,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              widget.visualMoves.isEmpty
                  ? '${whiteView ? "WHITE" : "BLACK"} VIEW · CAM ${cameraPreset + 1} · STYLE ${colorProfile + 1} · ROT ${(rotation * 57.2958).toStringAsFixed(0)}° · SPD ${playbackSpeedMs}ms · TILT ${tilt.toStringAsFixed(2)}'
                  : playbackIndex >= 0
                      ? 'PLAYBACK ${playbackIndex + 1}/${widget.visualMoves.length} · ${widget.visualMoves[playbackIndex]}'
                      : 'VISUAL CIPHER · ${widget.visualMoves.take(5).join("  ")}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFB08A2E),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 3),

            if (widget.visualMoves.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: LinearProgressIndicator(
                  value: playbackIndex < 0
                      ? 0
                      : (playbackIndex + 1) / widget.visualMoves.length,
                  minHeight: 4,
                  backgroundColor: const Color(0xFF151C23),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFB08A2E),
                  ),
                ),
              ),

            const SizedBox(height: 3),

            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF101820),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF263544)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _MiniLabel('VIEW'),
                    _ControlButton('⟲', () => setState(() => rotation -= pi / 8)),
                    _ControlButton('⟳', () => setState(() => rotation += pi / 8)),
                    _ControlButton('CAM', nextCameraPreset),
                    _ControlButton(whiteView ? 'WHITE' : 'BLACK', () => setState(() => whiteView = !whiteView)),

                    _MiniLabel('3D'),
                    _ControlButton('TILT+', () => setState(() => tilt -= 0.04)),
                    _ControlButton('TILT-', () => setState(() => tilt += 0.04)),
                    _ControlButton('STYLE', () => setState(() => colorProfile = (colorProfile + 1) % 3)),

                    _MiniLabel('LAYER'),
                    _ControlButton(showPieces ? 'PIECES' : 'NO PIECES', () => setState(() => showPieces = !showPieces)),
                    _ControlButton(showCoords ? 'COORDS' : 'NO COORDS', () => setState(() => showCoords = !showCoords)),

                    _MiniLabel('CIPHER'),
                    _ControlButton('SLOW', () => setState(() => playbackSpeedMs = 1300)),
                    _ControlButton('FAST', () => setState(() => playbackSpeedMs = 420)),
                    _ControlButton('PLAY', startPlayback),
                    _ControlButton('STOP', stopPlayback),
                    _ControlButton('RESET', resetView),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}





class _Piece3D extends StatelessWidget {
  final String piece;
  final double size;
  final bool white;
  final bool active;

  const _Piece3D({
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

class _MiniLabel extends StatelessWidget {
  final String text;

  const _MiniLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 3),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFB08A2E),
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ControlButton(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    final isReset = text == 'RESET';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        height: 24,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isReset ? const Color(0xFFD4AF37) : const Color(0xFF151C23),
            foregroundColor: isReset ? Colors.black : const Color(0xFFB08A2E),
            padding: const EdgeInsets.symmetric(horizontal: 5),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
