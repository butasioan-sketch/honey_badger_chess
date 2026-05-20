class ChessCodec {
  static const String letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static String encode(String text) {
    final result = <String>[];

    for (final char in text.toUpperCase().split('')) {
      if (char == ' ') {
        result.add('/');
        continue;
      }

      final index = letters.indexOf(char);
      if (index == -1) continue;

      final file = String.fromCharCode(97 + (index % 8));
      final rank = (index ~/ 8) + 1;

      result.add('$file$rank');
    }

    return result.join(' ');
  }

  static String decode(String code) {
    final result = StringBuffer();

    for (final part in code.split(' ')) {
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

      if (index >= 0 && index < letters.length) {
        result.write(letters[index]);
      }
    }

    return result.toString();
  }
}
