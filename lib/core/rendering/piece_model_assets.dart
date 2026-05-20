class PieceModelAssets {
  static String assetFor(String piece) {
    switch (piece) {
      case '♔':
      case '♚':
        return 'assets/3d/pieces/king.glb';

      case '♕':
      case '♛':
        return 'assets/3d/pieces/queen.glb';

      case '♖':
      case '♜':
        return 'assets/3d/pieces/rook.glb';

      case '♗':
      case '♝':
        return 'assets/3d/pieces/bishop.glb';

      case '♘':
      case '♞':
        return 'assets/3d/pieces/knight.glb';

      case '♙':
      case '♟':
        return 'assets/3d/pieces/pawn.glb';

      default:
        return 'assets/3d/pieces/pawn.glb';
    }
  }
}
