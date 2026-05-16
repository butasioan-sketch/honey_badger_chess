import 'package:flutter/material.dart';
import '../widgets/chess_board_widget.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF070B11),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: ChessBoardWidget(),
        ),
      ),
    );
  }
}
