import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get getIndexValue => _selectedIndex;
  void selectPage(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
