import 'package:flutter/material.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;

  const ChatScreen({
    super.key,
    required this.name,
    required this.avatarUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    // preload some messages
    _messages.addAll([
      {
        "fromMe": true,
        "type": "text",
        "text": "I'm meeting a friend here for dinner. How about you? 😊",
        "time": "5:30 PM"
      },
      {
        "fromMe": true,
        "type": "audio",
        "duration": "02:30",
        "time": "5:45 PM"
      },
      {
        "fromMe": true,
        "type": "text",
        "text": "I'm doing my homework, but I really need to take a break.",
        "time": "5:48 PM"
      },
      {
        "fromMe": false,
        "type": "text",
        "text":
            "On my way home but I needed to stop by the book store to buy a text book. 😎",
        "time": "5:58 PM"
      },
    ]);
    setState(() {});
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _simulateTyping() async {
    setState(() => _isTyping = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isTyping = false);

    // Add new message after typing simulation
    _messages.add({
      "fromMe": false,
      "type": "text",
      "text": "Haha nice! I'm almost home now 🏠",
      "time": "6:01 PM"
    });
    setState(() {});
    _scrollToBottom();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "fromMe": true,
        "type": "text",
        "text": text.trim(),
        "time": "Now"
      });
    });
    _scrollToBottom();

    // simulate a typing response after 2 seconds
    Future.delayed(const Duration(seconds: 2), _simulateTyping);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3D5AFE);
    const background = Color(0xFFF6F7FB);
    const textPrimary = Color(0xFF0A0A0A);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(radius: 20, backgroundImage: NetworkImage(widget.avatarUrl)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isTyping
                      ? const Text(
                          "typing...",
                          key: ValueKey("typing"),
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        )
                      : const Text(
                          "Online",
                          key: ValueKey("online"),
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final fromMe = msg["fromMe"] as bool;
                final animationDelay = index * 100;

                return TweenAnimationBuilder<double>(
                  key: ValueKey(index),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: msg["type"] == "audio"
                      ? _AudioBubble(
                          fromMe: fromMe,
                          duration: msg["duration"] as String,
                          time: msg["time"] as String,
                        )
                      : _TextBubble(
                          fromMe: fromMe,
                          text: msg["text"] as String,
                          time: msg["time"] as String,
                        ),
                );
              },
            ),
          ),
          _MessageInputBar(onSend: _sendMessage),
        ],
      ),
    );
  }
}

 

//
// ─── MESSAGE BUBBLE (TEXT + STATUS) ───────────────────────────────────────────────
//
class _TextBubble extends StatelessWidget {
  final bool fromMe;
  final String text;
  final String time;

  const _TextBubble({
    required this.fromMe,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3D5AFE);
    const bubbleColor = Colors.white;
    const textPrimary = Color(0xFF0A0A0A);
    const sentColor = Colors.grey;
    const deliveredColor = Colors.grey;
    const seenColor = Color(0xFF3D5AFE);

    final alignment =
        fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = fromMe ? primary : bubbleColor;
    final textColor = fromMe ? Colors.white : textPrimary;

    // Fake message states for demo (you can replace this later with real logic)
    // Options: "sent", "delivered", "seen"
    final randomStatus = ["sent", "delivered", "seen"];
    final status =
        fromMe ? (randomStatus[DateTime.now().second % 3]) : "none"; // simulate random

    IconData? _statusIcon() {
      switch (status) {
        case "sent":
          return Icons.check;
        case "delivered":
        case "seen":
          return Icons.done_all;
        default:
          return null;
      }
    }

    Color _statusColor() {
      switch (status) {
        case "sent":
          return sentColor;
        case "delivered":
          return deliveredColor;
        case "seen":
          return seenColor;
        default:
          return Colors.transparent;
      }
    }

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(vertical: 6),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(fromMe ? 18 : 0),
              bottomRight: Radius.circular(fromMe ? 0 : 18),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
        ),
        Row(
          mainAxisAlignment:
              fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (fromMe) ...[
              const SizedBox(width: 4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: Icon(
                  _statusIcon(),
                  key: ValueKey(status),
                  size: 16,
                  color: _statusColor(),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}





//
// ─── AUDIO BUBBLE ────────────────────────────────────────────────────────
//
class _AudioBubble extends StatelessWidget {
  final bool fromMe;
  final String duration;
  final String time;

  const _AudioBubble({
    required this.fromMe,
    required this.duration,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3D5AFE);

    final alignment =
        fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: fromMe ? primary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(fromMe ? 18 : 0),
              bottomRight: Radius.circular(fromMe ? 0 : 18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_fill,
                  color: fromMe ? Colors.white : primary, size: 32),
              const SizedBox(width: 10),
              Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: fromMe
                      ? Colors.white.withOpacity(0.4)
                      : Colors.grey.shade300,
                ),
                child: CustomPaint(painter: _WavePainter(fromMe: fromMe)),
              ),
              const SizedBox(width: 10),
              Text(
                duration,
                style: TextStyle(
                  color: fromMe ? Colors.white : Colors.black,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

//
// ─── SIMPLE WAVE VISUAL FOR AUDIO MESSAGE ────────────────────────────────
//
class _WavePainter extends CustomPainter {
  final bool fromMe;
  const _WavePainter({required this.fromMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fromMe ? Colors.white : const Color(0xFF3D5AFE)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 10; i++) {
      final x = i * (size.width / 10);
      final height = (i.isEven ? size.height * 0.8 : size.height * 0.4);
      canvas.drawLine(Offset(x, size.height / 2 - height / 2),
          Offset(x, size.height / 2 + height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//
// ─── MESSAGE INPUT BAR WITH SEND BUTTON ─────────────────────────────────
//
class _MessageInputBar extends StatefulWidget {
  final void Function(String) onSend;
  const _MessageInputBar({required this.onSend});

  @override
  State<_MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<_MessageInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3D5AFE);
    const background = Color(0xFFF6F7FB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: background,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Message...",
                  border: InputBorder.none,
                ),
                onSubmitted: widget.onSend,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              widget.onSend(_controller.text);
              _controller.clear();
            },
            child: Container(
              decoration: const BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
