//chat.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_firebase/presentation/pages/services/provider.dart';
import 'package:project_firebase/presentation/widget/chat_message.dart';
import 'package:project_firebase/presentation/widget/list_chat.dart';
import 'package:project_firebase/presentation/widget/new_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    Column(
      children: const [Expanded(child: ChatMessages()), NewMessage()],
    ),
    Container(
      child: ListMessages(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                context.pushReplacement('/');
              },
              icon: Icon(Icons.logout))
        ],
        title: const Text('FlutterChat'),
      ),
      body: Consumer<SetProvider>(
        builder: (context, value, child) {
          return Center(
            child: _widgetOptions.elementAt(value.getIndexValue),
          );
        },
      ),
      bottomNavigationBar: Consumer<SetProvider>(
        builder: (context, value, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Group Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Personal Chat',
              ),
            ],
            currentIndex: value.getIndexValue,
            selectedItemColor: Colors.amber,
            onTap: (value) {
              context.read<SetProvider>().selectPage(value);
            },
          );
        },
      ),
    );
  }
}
