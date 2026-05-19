import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/offline_chess_cipher.dart';
import '../../core/services/encrypted_session_service.dart';
import '../../core/network/session_envelope_service.dart';
import '../../core/network/i2p_overlay_service.dart';
import '../../widgets/chess_board_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final encryptController = TextEditingController();
  final decryptController = TextEditingController();

  final weekKeyController = TextEditingController(text: 'WEEK-01-HONEY');
  final gameSeedController = TextEditingController(text: 'FISCHER-PATTERN-001');
  final profileCodeController = TextEditingController();

  String encryptedOutput = 'Offline Cipher erscheint hier...';
  String decryptedOutput = 'Entschlüsselter Text erscheint hier...';
  String visualMoveSource = '';
  String envelopeStatus = 'Envelope: keiner';

  String filterMode = 'COLD-WAR';
  bool blackPerspective = false;
  EncryptedSession? activeSession;
  final sessionCodeController = TextEditingController();
  final i2pService = I2POverlayService();
  String i2pStatus = 'I2P: nicht geprüft';

  CipherProfile get profile {
    final session = activeSession;

    return CipherProfile(
      weekKey: session == null
          ? weekKeyController.text
          : '\${weekKeyController.text}|\${session.sessionKey}',
      gameSeed: session == null
          ? gameSeedController.text
          : '\${gameSeedController.text}|\${session.sessionId}|\${session.challenge}',
      filterMode: session == null
          ? filterMode
          : '\$filterMode|\${session.response}',
      blackPerspective: blackPerspective,
    );
  }

  void encrypt() {
    setState(() {
      encryptedOutput = OfflineChessCipher.encryptToMoves(
        encryptController.text,
        profile,
      );
      visualMoveSource = encryptedOutput;
    });
  }

  void decrypt() {
    final envelope = SessionEnvelopeService.unpack(decryptController.text);

    final payload = envelope == null
        ? decryptController.text
        : envelope.payload;

    setState(() {
      if (envelope == null) {
        envelopeStatus = 'Envelope: keiner';
      } else if (activeSession == null) {
        envelopeStatus = 'Envelope erkannt · keine aktive Session';
      } else if (envelope.sessionFingerprint == activeSession!.fingerprint) {
        envelopeStatus = 'Envelope OK · Session passt';
      } else {
        envelopeStatus = 'Envelope WARNUNG · Session passt NICHT';
      }

      decryptedOutput = OfflineChessCipher.decryptFromMoves(
        payload,
        profile,
      );

      visualMoveSource = payload;
    });
  }

  String fingerprint() {
    return profile.fingerprint.hashCode.abs().toString().padLeft(10, '0').substring(0, 10);
  }

  void copyEncrypted() {
    final payload = activeSession == null
        ? encryptedOutput
        : SessionEnvelopeService.pack(
            sessionFingerprint: activeSession!.fingerprint,
            encryptedPayload: encryptedOutput,
          );

    Clipboard.setData(ClipboardData(text: payload));

    setState(() {
      decryptController.text = payload;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cipher/Envelope kopiert und in Decrypt eingefügt')),
    );
  }

  Future<void> checkI2P() async {
    setState(() {
      i2pStatus = 'I2P: prüfe...';
    });

    final state = await i2pService.checkLocalRouter();

    setState(() {
      i2pStatus = state == I2PConnectionState.available
          ? 'I2P: verfügbar'
          : 'I2P: nicht verfügbar';
    });
  }

  void createSession() {
    setState(() {
      activeSession = EncryptedSessionService.createSession();
      sessionCodeController.text = activeSession!.exportCode();
    });

    Clipboard.setData(ClipboardData(text: sessionCodeController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session erstellt und kopiert')),
    );
  }

  void burnSession() {
    setState(() {
      activeSession = null;
      sessionCodeController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session verbrannt')),
    );
  }

  void exportProfile() {
    final code = OfflineChessCipher.exportProfile(profile);
    profileCodeController.text = code;
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil exportiert und kopiert')),
    );
  }

  void importProfile() {
    final imported = OfflineChessCipher.importProfile(profileCodeController.text);

    if (imported == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ungültiger Profile-Code')),
      );
      return;
    }

    setState(() {
      weekKeyController.text = imported.weekKey;
      gameSeedController.text = imported.gameSeed;
      filterMode = imported.filterMode;
      blackPerspective = imported.blackPerspective;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Image.asset('assets/logos/honey_badger_logo.png', width: 36),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'HONEY BADGER CHESS',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Icon(Icons.security, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 12),
                    const Icon(Icons.bar_chart, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 12),
                    const Icon(Icons.person, color: Color(0xFFD4AF37)),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 46,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Expanded(child: _SmallCard('● Online\nCommander Jonny')),
                    const SizedBox(width: 10),
                    _SmallCenterCard(text: '🔒 FP ${fingerprint()}'),
                    const SizedBox(width: 10),
                    const Expanded(child: _SmallCard('● Online\nOpponent')),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 1200 ? 205 : 250,
                      child: _LeftCipherPanel(
                        weekKeyController: weekKeyController,
                        gameSeedController: gameSeedController,
                        profileCodeController: profileCodeController,
                        filterMode: filterMode,
                        blackPerspective: blackPerspective,
                        onFilterChanged: (value) {
                          setState(() => filterMode = value ?? 'COLD-WAR');
                        },
                        onPerspectiveChanged: (value) {
                          setState(() => blackPerspective = value);
                        },
                        onExport: exportProfile,
                        onImport: importProfile,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ChessBoardWidget(
                        visualMoves: encryptedOutput
                            .split(RegExp(r'\s+'))
                            .where((m) => m.contains('-'))
                            .take(32)
                            .toList(),
                      ),
                    ),

                    const SizedBox(width: 10),

                    SizedBox(
                      width: MediaQuery.of(context).size.width < 1200 ? 205 : 250,
                      child: _RightCipherPanel(
                        encryptController: encryptController,
                        decryptController: decryptController,
                        encryptedOutput: encryptedOutput,
                        decryptedOutput: decryptedOutput,
                        envelopeStatus: envelopeStatus,
                        onEncrypt: encrypt,
                        onDecrypt: decrypt,
                        onCopy: copyEncrypted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftCipherPanel extends StatelessWidget {
  final TextEditingController weekKeyController;
  final TextEditingController gameSeedController;
  final TextEditingController profileCodeController;
  final String filterMode;
  final bool blackPerspective;
  final ValueChanged<String?> onFilterChanged;
  final ValueChanged<bool> onPerspectiveChanged;
  final VoidCallback onExport;
  final VoidCallback onImport;

  const _LeftCipherPanel({
    required this.weekKeyController,
    required this.gameSeedController,
    required this.profileCodeController,
    required this.filterMode,
    required this.blackPerspective,
    required this.onFilterChanged,
    required this.onPerspectiveChanged,
    required this.onExport,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return _SidePanel(
      title: 'CIPHER PROFILE',
      child: Column(
        children: [
          _Input(controller: weekKeyController, hint: 'Wochen-Key'),
          const SizedBox(height: 8),
          _Input(controller: gameSeedController, hint: 'Partie-Muster'),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: filterMode,
            dropdownColor: const Color(0xFF101820),
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'COLD-WAR', child: Text('COLD-WAR')),
              DropdownMenuItem(value: 'FISCHER', child: Text('FISCHER')),
              DropdownMenuItem(value: 'SHADOW', child: Text('SHADOW')),
            ],
            onChanged: onFilterChanged,
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Black Perspective',
                  style: TextStyle(fontSize: 11),
                ),
              ),
              Switch(
                value: blackPerspective,
                activeThumbColor: const Color(0xFFD4AF37),
                onChanged: onPerspectiveChanged,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onExport,
                  child: const Text('EXPORT', style: TextStyle(fontSize: 10)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onImport,
                  child: const Text('IMPORT', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _Input(controller: profileCodeController, hint: 'Profile-Code'),
        ],
      ),
    );
  }
}

class _RightCipherPanel extends StatelessWidget {
  final TextEditingController encryptController;
  final TextEditingController decryptController;
  final String encryptedOutput;
  final String decryptedOutput;
  final String envelopeStatus;
  final VoidCallback onEncrypt;
  final VoidCallback onDecrypt;
  final VoidCallback onCopy;

  const _RightCipherPanel({
    required this.encryptController,
    required this.decryptController,
    required this.encryptedOutput,
    required this.decryptedOutput,
    required this.envelopeStatus,
    required this.onEncrypt,
    required this.onDecrypt,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return _SidePanel(
      title: 'OFFLINE CIPHER',
      child: Column(
        children: [
          _Input(controller: encryptController, hint: 'Text encrypten...'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onEncrypt,
                  icon: const Icon(Icons.lock, size: 14),
                  label: const Text('ENCRYPT', style: TextStyle(fontSize: 10)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onCopy,
                icon: const Icon(Icons.copy, size: 18),
                color: const Color(0xFFD4AF37),
              ),
            ],
          ),
          Expanded(child: _Output(text: encryptedOutput)),
          const SizedBox(height: 8),
          _Input(controller: decryptController, hint: 'Move-Code decrypten...'),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onDecrypt,
            icon: const Icon(Icons.lock_open, size: 14),
            label: const Text('DECRYPT', style: TextStyle(fontSize: 10)),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: envelopeStatus.contains('OK')
                  ? const Color(0xFF0F2A18)
                  : envelopeStatus.contains('WARNUNG')
                      ? const Color(0xFF3A1111)
                      : const Color(0xFF050A10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: envelopeStatus.contains('OK')
                    ? Colors.greenAccent
                    : envelopeStatus.contains('WARNUNG')
                        ? Colors.redAccent
                        : const Color(0xFF33465A),
              ),
            ),
            child: Text(
              envelopeStatus,
              style: const TextStyle(
                color: Color(0xFFFFD76A),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: _Output(text: decryptedOutput)),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _Input({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 11),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFF070B11),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _Output extends StatelessWidget {
  final String text;

  const _Output({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF050A10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: SelectableText(
          text,
          style: const TextStyle(
            color: Color(0xFFFFD76A),
            fontSize: 11,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String text;
  const _SmallCard(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D151D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF33465A)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.white)),
    );
  }
}

class _SmallCenterCard extends StatelessWidget {
  final String text;
  const _SmallCenterCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF0D151D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD4AF37),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  final String title;
  final Widget child;

  const _SidePanel({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D151D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF33465A)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
