import 'package:assignment/Screens/add_students.dart';
import 'package:assignment/Screens/all_students.dart';
import 'package:assignment/Screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AddStudentPage(),
    AllStudentsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Assignment'),
        backgroundColor: Colors.black,
        actions: [
          const CircleAvatar(
            radius: 17,
            foregroundImage: AssetImage('assets/images/person.jpeg'),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                });
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: Text('Sign Out'),
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        backgroundColor: Colors.black,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_rounded),
              label: 'Add Students'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'All Students')
        ],
      ),
    );
  }
}
