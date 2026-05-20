import 'dart:convert';

class CipherProfile {
  final String weekKey;
  final String gameSeed;
  final String filterMode;
  final bool blackPerspective;

  const CipherProfile({
    required this.weekKey,
    required this.gameSeed,
    required this.filterMode,
    required this.blackPerspective,
  });

  String get fingerprint =>
      '$weekKey|$gameSeed|$filterMode|${blackPerspective ? "BLACK" : "WHITE"}';
}

class OfflineChessCipher {
  static const String alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,?!';

  static String exportProfile(CipherProfile profile) {
    final raw = [
      profile.weekKey,
      profile.gameSeed,
      profile.filterMode,
      profile.blackPerspective ? 'BLACK' : 'WHITE',
    ].join('::');

    return base64Url.encode(utf8.encode(raw));
  }

  static CipherProfile? importProfile(String code) {
    try {
      final raw = utf8.decode(base64Url.decode(code.trim()));
      final parts = raw.split('::');

      if (parts.length != 4) return null;

      return CipherProfile(
        weekKey: parts[0],
        gameSeed: parts[1],
        filterMode: parts[2],
        blackPerspective: parts[3] == 'BLACK',
      );
    } catch (_) {
      return null;
    }
  }

  static int _hash(String input) {
    int hash = 2166136261;

    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }

    return hash;
  }

  static List<String> _squares(bool blackPerspective) {
    final result = <String>[];

    for (int rank = 1; rank <= 8; rank++) {
      for (int file = 0; file < 8; file++) {
        result.add('${String.fromCharCode(97 + file)}$rank');
      }
    }

    return blackPerspective ? result.reversed.toList() : result;
  }

  static String _moveForSymbol({
    required String symbol,
    required int position,
    required CipherProfile profile,
  }) {
    final squares = _squares(profile.blackPerspective);

    final seed = _hash(
      '${profile.fingerprint}|REAL|$symbol|POSITION:$position|HONEY-BADGER-V3',
    );

    var fromIndex = seed % squares.length;
    var toIndex = (seed ~/ 131) % squares.length;

    if (fromIndex == toIndex) {
      toIndex = (toIndex + 17) % squares.length;
    }

    return '${squares[fromIndex]}-${squares[toIndex]}';
  }

  static String _noiseMove({
    required int realPosition,
    required int noiseIndex,
    required CipherProfile profile,
  }) {
    final squares = _squares(profile.blackPerspective);

    final seed = _hash(
      '${profile.fingerprint}|NOISE|$realPosition|$noiseIndex|HONEY-BADGER-V3',
    );

    var fromIndex = seed % squares.length;
    var toIndex = (seed ~/ 197) % squares.length;

    if (fromIndex == toIndex) {
      toIndex = (toIndex + 23) % squares.length;
    }

    return 'x:${squares[fromIndex]}-${squares[toIndex]}';
  }

  static int _noiseCount(int position, CipherProfile profile) {
    final seed = _hash('${profile.fingerprint}|NOISECOUNT|$position');
    return seed % 3;
  }

  static String encryptToMoves(String text, CipherProfile profile) {
    final result = <String>[];
    int position = 0;

    for (final char in text.toUpperCase().split('')) {
      if (!alphabet.contains(char)) continue;

      result.add(
        _moveForSymbol(
          symbol: char,
          position: position,
          profile: profile,
        ),
      );

      final noiseCount = _noiseCount(position, profile);

      for (int i = 0; i < noiseCount; i++) {
        result.add(
          _noiseMove(
            realPosition: position,
            noiseIndex: i,
            profile: profile,
          ),
        );
      }

      position++;
    }

    return result.join(' ');
  }

  static String decryptFromMoves(String code, CipherProfile profile) {
    final allMoves = code
        .trim()
        .split(RegExp(r'\s+'))
        .where((m) => m.isNotEmpty && !m.startsWith('x:'))
        .toList();

    final buffer = StringBuffer();

    for (int position = 0; position < allMoves.length; position++) {
      final move = allMoves[position];
      String? found;

      for (final symbol in alphabet.split('')) {
        final candidate = _moveForSymbol(
          symbol: symbol,
          position: position,
          profile: profile,
        );

        if (candidate == move) {
          found = symbol;
          break;
        }
      }

      if (found != null) {
        buffer.write(found);
      }
    }

    return buffer.toString();
  }
}
