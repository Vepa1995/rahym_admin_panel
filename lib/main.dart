import 'package:flutter/material.dart';
import 'package:rahym_admin_panel/screens/chat/chat_screen.dart';
import 'package:rahym_admin_panel/screens/lenta_screen.dart';
import 'package:rahym_admin_panel/screens/profile_screen.dart';
import 'package:rahym_admin_panel/screens/transfer_screen.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rahym Admin Panel",
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  final pages = const [
    ChatsScreen(),
    TransferScreen(),
    LentaAdminScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: "Chats"),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: "Transfer"),
          NavigationDestination(icon: Icon(Icons.dynamic_feed), label: "Lenta"),
          NavigationDestination(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }
}
