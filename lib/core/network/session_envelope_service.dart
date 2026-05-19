import 'dart:convert';

import 'i2p_overlay_service.dart';

class SessionEnvelopeService {
  static String pack({
    required String sessionFingerprint,
    required String encryptedPayload,
  }) {
    final envelope = I2PMessageEnvelope(
      sessionFingerprint: sessionFingerprint,
      payload: encryptedPayload,
      timestamp: DateTime.now().toIso8601String(),
      routeHint: 'local-offline-or-i2p',
    );

    return base64Url.encode(utf8.encode(jsonEncode(envelope.toJson())));
  }

  static I2PMessageEnvelope? unpack(String code) {
    try {
      final raw = utf8.decode(base64Url.decode(code.trim()));
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return I2PMessageEnvelope.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
