// Packages
import 'package:flutter/material.dart';

// Pages
import '../pages/chats_page.dart';
import '../pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final List<Widget> _pages = [ ChatsPage(),  UsersPage()];

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (_index) {
          setState(() {
            _currentPageIndex = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),
        ],
      ),
    );
  }
}
