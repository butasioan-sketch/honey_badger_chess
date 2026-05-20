import 'dart:async';
import 'dart:io';

enum I2PConnectionState {
  offline,
  checking,
  available,
  unavailable,
}

class I2PMessageEnvelope {
  final String sessionFingerprint;
  final String payload;
  final String timestamp;
  final String routeHint;
  final bool burned;

  const I2PMessageEnvelope({
    required this.sessionFingerprint,
    required this.payload,
    required this.timestamp,
    required this.routeHint,
    this.burned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionFingerprint': sessionFingerprint,
      'payload': payload,
      'timestamp': timestamp,
      'routeHint': routeHint,
      'burned': burned,
    };
  }

  factory I2PMessageEnvelope.fromJson(Map<String, dynamic> json) {
    return I2PMessageEnvelope(
      sessionFingerprint: json['sessionFingerprint'] ?? '',
      payload: json['payload'] ?? '',
      timestamp: json['timestamp'] ?? '',
      routeHint: json['routeHint'] ?? '',
      burned: json['burned'] == true,
    );
  }
}

class I2POverlayService {
  I2PConnectionState state = I2PConnectionState.offline;

  Future<bool> _canConnect(int port) async {
    try {
      final socket = await Socket.connect(
        '127.0.0.1',
        port,
        timeout: const Duration(milliseconds: 600),
      );

      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<I2PConnectionState> checkLocalRouter() async {
    state = I2PConnectionState.checking;

    final routerConsole = await _canConnect(7657);
    final samBridge = await _canConnect(7656);
    final httpProxy = await _canConnect(4444);

    if (routerConsole || samBridge || httpProxy) {
      state = I2PConnectionState.available;
    } else {
      state = I2PConnectionState.unavailable;
    }

    return state;
  }

  I2PMessageEnvelope createEnvelope({
    required String sessionFingerprint,
    required String encryptedPayload,
  }) {
    return I2PMessageEnvelope(
      sessionFingerprint: sessionFingerprint,
      payload: encryptedPayload,
      timestamp: DateTime.now().toIso8601String(),
      routeHint: 'i2p-local-router',
    );
  }
}
