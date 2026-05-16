class ChessCodeService {
  static const List<String> _letters = [
    'A','B','C','D','E','F','G','H',
    'I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X',
    'Y','Z'
  ];

  static String encode(String text) {
    final cleaned = text.toUpperCase();
    final result = <String>[];

    for (final char in cleaned.split('')) {
      if (char == ' ') {
        result.add('/');
        continue;
      }

      final index = _letters.indexOf(char);
      if (index == -1) continue;

      final file = String.fromCharCode(97 + (index % 8));
      final rank = (index ~/ 8) + 1;
      result.add('$file$rank');
    }

    return result.join(' ');
  }

  static String decode(String code) {
    final parts = code.trim().split(RegExp(r'\s+'));
    final result = StringBuffer();

    for (final part in parts) {
      if (part == '/') {
        result.write(' ');
        continue;
      }

      if (part.length < 2) continue;

      final file = part[0].toLowerCase();
      final rank = int.tryParse(part.substring(1));
      if (rank == null) continue;

      final col = file.codeUnitAt(0) - 97;
      final row = rank - 1;
      final index = row * 8 + col;

      if (index >= 0 && index < _letters.length) {
        result.write(_letters[index]);
      }
    }

    return result.toString();
  }
}
