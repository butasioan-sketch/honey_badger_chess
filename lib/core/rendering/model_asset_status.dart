import 'piece_model_assets.dart';

class ModelAssetStatus {
  static const expectedAssets = [
    'assets/3d/pieces/king.glb',
    'assets/3d/pieces/queen.glb',
    'assets/3d/pieces/rook.glb',
    'assets/3d/pieces/bishop.glb',
    'assets/3d/pieces/knight.glb',
    'assets/3d/pieces/pawn.glb',
  ];

  static String expectedForPiece(String piece) {
    return PieceModelAssets.assetFor(piece);
  }

  static String get summary {
    return '3D Models: prepared, waiting for GLB assets';
  }
}
