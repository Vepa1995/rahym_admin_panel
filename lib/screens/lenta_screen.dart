import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LentaAdminScreen extends StatefulWidget {
  const LentaAdminScreen({super.key});

  @override
  State<LentaAdminScreen> createState() => _LentaAdminScreenState();
}

class _LentaAdminScreenState extends State<LentaAdminScreen> {
  final _textC = TextEditingController();
  final _picker = ImagePicker();
  File? _pickedImage;

  final _posts = <Map<String, dynamic>>[
    {"text": "Täze aksiýa!", "image": null, "createdAt": DateTime.now()},
  ];

  Future<void> _pickImage() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _pickedImage = File(x.path));
  }

  void _publish() {
    if (_textC.text.trim().isEmpty && _pickedImage == null) return;
    setState(() {
      _posts.insert(0, {
        "text": _textC.text.trim(),
        "image": _pickedImage,
        "createdAt": DateTime.now(),
      });
      _textC.clear();
      _pickedImage = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post published (UI)")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lenta (Admin posts)")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Create post
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _textC,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Tekst ýaz...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.image_outlined),
                        label: const Text("Surat saýla"),
                        onPressed: _pickImage,
                      ),
                      const SizedBox(width: 12),
                      if (_pickedImage != null)
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_pickedImage!, height: 80, fit: BoxFit.cover),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _publish,
                      icon: const Icon(Icons.send),
                      label: const Text("Paylaş"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          const Text("Siziň postlaryňyz", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),

          // Posts list (admin tarapyndan goýlanlar)
          ..._posts.map((p) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p["image"] != null) Image.file(p["image"], height: 180, width: double.infinity, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(p["text"] ?? ""),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
