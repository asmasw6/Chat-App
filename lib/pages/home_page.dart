import 'package:flutter/material.dart';
import 'package:sukoon/pages/chats_page.dart';
import 'package:sukoon/pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final List<Widget> pages = [
    ChatsPage(),
    UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: "Users",
          ),
        ],

        selectedItemColor:
            Color.fromRGBO(13, 65, 154, 1), // Color of the selected item
        unselectedItemColor: Colors.grey, // Color of the unselected items
      ),
    );
  }
}
