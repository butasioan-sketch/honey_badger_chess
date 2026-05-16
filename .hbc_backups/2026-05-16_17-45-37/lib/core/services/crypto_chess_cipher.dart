class CryptoChessCipher {
  static const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const int secretShift = 7;

  static String encryptText(String input) {
    final buffer = StringBuffer();

    for (final char in input.toUpperCase().split('')) {
      if (char == ' ') {
        buffer.write(' ');
        continue;
      }

      final index = alphabet.indexOf(char);
      if (index == -1) continue;

      buffer.write(alphabet[(index + secretShift) % alphabet.length]);
    }

    return buffer.toString();
  }

  static String decryptText(String input) {
    final buffer = StringBuffer();

    for (final char in input.toUpperCase().split('')) {
      if (char == ' ') {
        buffer.write(' ');
        continue;
      }

      final index = alphabet.indexOf(char);
      if (index == -1) continue;

      buffer.write(alphabet[(index - secretShift + alphabet.length) % alphabet.length]);
    }

    return buffer.toString();
  }

  static String textToChessCode(String text) {
    final encrypted = encryptText(text);
    final result = <String>[];

    for (final char in encrypted.split('')) {
      if (char == ' ') {
        result.add('/');
        continue;
      }

      final index = alphabet.indexOf(char);
      if (index == -1) continue;

      final file = String.fromCharCode(97 + (index % 8));
      final rank = (index ~/ 8) + 1;
      result.add('$file$rank');
    }

    return result.join(' ');
  }

  static String chessCodeToText(String code) {
    final parts = code.trim().split(RegExp(r'\s+'));
    final encrypted = StringBuffer();

    for (final part in parts) {
      if (part == '/') {
        encrypted.write(' ');
        continue;
      }

      if (part.length < 2) continue;

      final file = part[0].toLowerCase();
      final rank = int.tryParse(part.substring(1));
      if (rank == null) continue;

      final col = file.codeUnitAt(0) - 97;
      final row = rank - 1;
      final index = row * 8 + col;

      if (index >= 0 && index < alphabet.length) {
        encrypted.write(alphabet[index]);
      }
    }

    return decryptText(encrypted.toString());
  }
}
