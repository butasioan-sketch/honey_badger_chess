import 'dart:convert';
import 'dart:math';

class EncryptedSession {
  final String sessionId;
  final String sessionKey;
  final String challenge;
  final String response;
  final DateTime createdAt;

  const EncryptedSession({
    required this.sessionId,
    required this.sessionKey,
    required this.challenge,
    required this.response,
    required this.createdAt,
  });

  bool get isExpired {
    return DateTime.now().difference(createdAt).inMinutes >= 30;
  }

  Duration get remaining {
    final elapsed = DateTime.now().difference(createdAt);
    final left = const Duration(minutes: 30) - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  String get fingerprint {
    final raw = '$sessionId|$sessionKey|$challenge|$response';
    return raw.hashCode.abs().toString().padLeft(10, '0').substring(0, 10);
  }

  String exportCode() {
    final raw = [
      sessionId,
      sessionKey,
      challenge,
      response,
      createdAt.toIso8601String(),
    ].join('::');

    return base64Url.encode(utf8.encode(raw));
  }

  static EncryptedSession? importCode(String code) {
    try {
      final raw = utf8.decode(base64Url.decode(code.trim()));
      final parts = raw.split('::');

      if (parts.length != 5) return null;

      return EncryptedSession(
        sessionId: parts[0],
        sessionKey: parts[1],
        challenge: parts[2],
        response: parts[3],
        createdAt: DateTime.parse(parts[4]),
      );
    } catch (_) {
      return null;
    }
  }
}

class EncryptedSessionService {
  static const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String _randomToken(int length) {
    final random = Random.secure();

    return List.generate(
      length,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }

  static EncryptedSession createSession() {
    return EncryptedSession(
      sessionId: 'HB-${_randomToken(4)}-${_randomToken(4)}',
      sessionKey: '${_randomToken(6)}-${_randomToken(6)}',
      challenge: 'VERIFY-${_randomToken(5)}',
      response: 'ANSWER-${_randomToken(5)}',
      createdAt: DateTime.now(),
    );
  }
}
