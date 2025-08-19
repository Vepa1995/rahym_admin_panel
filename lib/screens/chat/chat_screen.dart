import 'package:flutter/material.dart';
import '../../models/chat_models.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = <Contact>[
      Contact(
        id: "u1",
        name: "Aýnur",
        avatarUrl: "https://i.pravatar.cc/150?img=1",
        lastMessage: "Sag boluň!",
        updatedAt: DateTime.now(),
      ),
      Contact(
        id: "u2",
        name: "Merdan",
        avatarUrl: "https://i.pravatar.cc/150?img=2",
        lastMessage: "Habar gowşdy",
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Chats (Customers)")),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (_, i) {
          final c = contacts[i];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(c.avatarUrl)),
            title: Text(c.name),
            subtitle: Text(c.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatDetailScreen(contact: c)),
              );
            },
          );
        },
      ),
    );
  }
}
