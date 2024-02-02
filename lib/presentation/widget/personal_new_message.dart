//new_message
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/data.dart';

class NewPersonalMessage extends StatefulWidget {
  NewPersonalMessage({super.key, required this.room});
  var room;

  @override
  State<NewPersonalMessage> createState() {
    return _NewPersonalMessageState(room: this.room);
  }
}

class _NewPersonalMessageState extends State<NewPersonalMessage> {
  var _messageController = TextEditingController();
  var room;
  _NewPersonalMessageState({required this.room});

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
  }

  Future<void> _submitMessage() async {
    final enteredMessage = _messageController.text;
    File? _selectedImage = this._pickedImageFile;
    String? imageUrl = '';

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    if (_selectedImage != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('image_message.jpg');

      await storageRef.putFile(_selectedImage!);
      imageUrl = await storageRef.getDownloadURL();
    }
    ;

    // send to Firebase
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection("personal")
        .doc([user.uid,room] as String?)
        .get();

    FirebaseFirestore.instance.collection('personal').add({
      'text': enteredMessage,
      'room': room,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

    _pickedImageFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
              onPressed: () {
                _pickImage();
              },
              icon: Icon(Icons.photo)),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.send,
              ),
              onPressed: _submitMessage)
        ],
      ),
    );
  }
}
