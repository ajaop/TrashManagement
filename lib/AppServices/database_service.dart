import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trash_management/AppServices/auth_service.dart';

import '../Models/user_details.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  User? user;

  DatabaseService() {
    user = auth.currentUser;
  }

  Stream<UserDetails> getUserDetails() {
    return _db
        .collection("users")
        .where('userId', isEqualTo: user!.uid)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => UserDetails.fromFirestore(document.data()))
            .first);
  }

  void displayError(errorMessage, _messangerKey) {
    _messangerKey.currentState!.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 5),
        elevation: 0,
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        )));

    Timer(Duration(seconds: 5), () {
      _messangerKey.currentState!.hideCurrentSnackBar();
    });
  }
}
