import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/chat_models.dart';

class ChatDetailScreen extends StatefulWidget {
  final Contact contact;
  const ChatDetailScreen({super.key, required this.contact});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messages = <Message>[
    Message(id: "m1", sender: "user", text: "Salam admin!", createdAt: DateTime.now().subtract(const Duration(minutes: 2))),
    Message(id: "m2", sender: "admin", text: "Salam! Nähili kömek?", createdAt: DateTime.now().subtract(const Duration(minutes: 1))),
  ];
  final _c = TextEditingController();
  final _picker = ImagePicker();

  void _sendText() {
    final t = _c.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages.add(Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sender: "admin",
        text: t,
        createdAt: DateTime.now(),
      ));
    });
    _c.clear();
  }

  Future<void> _sendImage() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    setState(() {
      _messages.add(Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sender: "admin",
        text: "",
        imagePath: xfile.path,
        createdAt: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.contact.avatarUrl)),
            const SizedBox(width: 8),
            Text(widget.contact.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages.reversed.toList()[i];
                final isAdmin = msg.sender == "admin";
                final align = isAdmin ? Alignment.centerRight : Alignment.centerLeft;
                final color = isAdmin ? Colors.teal.shade100 : Colors.grey.shade200;

                return Align(
                  alignment: align,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.text.isNotEmpty) Text(msg.text),
                        if (msg.imagePath != null) ...[
                          const SizedBox(height: 6),
                          Image.file(File(msg.imagePath!), width: 200),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.image_outlined), onPressed: _sendImage),
                Expanded(
                  child: TextField(
                    controller: _c,
                    decoration: const InputDecoration(
                      hintText: "Haty ýaz...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
