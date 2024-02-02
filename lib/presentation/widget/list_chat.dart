//chat_message

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_firebase/presentation/widget/message_bubble.dart';

class ListMessages extends StatelessWidget {
  const ListMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    // print(authenticatedUser);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('personal')
          .doc(authenticatedUser.uid)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData) {
          return const Center(
            child: Text('No chat found.'),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final loadedChat = chatSnapshots.data!;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedChat.toString().length,
          itemBuilder: (ctx, index) {
            return Text(loadedChat[0]);
          },
        );
      },
    );
  }
}
