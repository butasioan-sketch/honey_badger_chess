import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/services/crypto_chess_cipher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();

  final List<ChatMessage> messages = [
    ChatMessage(
      text: 'HALLO COMMANDER',
      encrypted: CryptoChessCipher.textToChessCode('HALLO COMMANDER'),
      own: false,
    ),
  ];

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.insert(
        0,
        ChatMessage(
          text: text,
          encrypted: CryptoChessCipher.textToChessCode(text),
          own: true,
        ),
      );
      controller.clear();
    });
  }

  void clearChat() {
    setState(() {
      messages.clear();
    });
  }

  void copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code kopiert')),
    );
  }

  void decrypt(ChatMessage msg) {
    final decoded = CryptoChessCipher.chessCodeToText(msg.encrypted);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF101820),
        title: const Text(
          'Entschlüsselt',
          style: TextStyle(color: Color(0xFFD4AF37)),
        ),
        content: SelectableText(
          decoded,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B11),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Encrypted Chat',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: clearChat,
                    icon: const Icon(Icons.delete_outline),
                    color: const Color(0xFFD4AF37),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  return Align(
                    alignment:
                        msg.own ? Alignment.centerRight : Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => decrypt(msg),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.62,
                        ),
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: msg.own
                              ? const Color(0xFFE8DFC8)
                              : const Color(0xFF17202A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: msg.own
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF263544),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              msg.encrypted,
                              style: TextStyle(
                                color: msg.own
                                    ? Colors.black
                                    : const Color(0xFFD4AF37),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Tippen zum Entschlüsseln',
                                  style: TextStyle(
                                    color: msg.own
                                        ? Colors.black54
                                        : Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => copyCode(msg.encrypted),
                                  child: Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: msg.own
                                        ? Colors.black54
                                        : Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF17202A),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (_) => send(),
                        decoration: const InputDecoration(
                          hintText: 'Nachricht eingeben...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: send,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.lock, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String encrypted;
  final bool own;

  ChatMessage({
    required this.text,
    required this.encrypted,
    required this.own,
  });
}
