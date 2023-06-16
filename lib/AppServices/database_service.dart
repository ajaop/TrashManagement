import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/user_details.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  DatabaseService() {
    user = auth.currentUser;
  }

  Stream<List<UserDetails>> getUserDetails() {
    Future<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
        .instance
        .collection("users")
        .where('userId', isEqualTo: user!.uid)
        .limit(1)
        .get();

    return snapshot
        .map((docSnapshot) => UserDetails.fromFirestore(docSnapshot))
        .toList();

    return _db.collection('Products').snapshots().map((snapshot) => snapshot
        .documents
        .map((document) => Product.fromFirestore(document.data))
        .toList());
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
