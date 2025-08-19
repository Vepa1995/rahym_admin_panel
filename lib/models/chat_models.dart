class Contact {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final DateTime updatedAt;

  Contact({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.updatedAt,
  });
}

class Message {
  final String id;
  final String sender; // "admin" ýa-da "user"
  final String text;
  final String? imagePath; // local image path (UI üçin)
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.text,
    this.imagePath,
    required this.createdAt,
  });
}
