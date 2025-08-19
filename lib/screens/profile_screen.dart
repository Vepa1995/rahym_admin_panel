import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: ListView(
        children: const [
          SizedBox(height: 24),
          CircleAvatar(radius: 48, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5")),
          SizedBox(height: 12),
          Center(child: Text("Admin Rahym", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text("Settings"),
            subtitle: Text("Dark mode, dil, bildirişler"),
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text("Bildirişler"),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Çykmak"),
          ),
        ],
      ),
    );
  }
}
