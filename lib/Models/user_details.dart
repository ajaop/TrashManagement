import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? gender;
  String? profileImageUrl;
  int? points;
  String? userId;
  DateTime? accountCreationDate;

  UserDetails(
      {required this.firstname,
      required this.lastname,
      required this.email,
      required this.gender,
      required this.profileImageUrl,
      required this.points,
      required this.userId,
      required this.accountCreationDate});

  UserDetails.dashboard();

  UserDetails.signin({required this.email, required this.password});

  Map<String, dynamic> createMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'points': points,
      'userId': userId,
      'accountCreationDate': accountCreationDate
    };
  }

  UserDetails.fromFirestore(Map<String, dynamic> firestoreMap)
      : firstname = firestoreMap['firstname'],
        lastname = firestoreMap['lastname'],
        email = firestoreMap['email'],
        gender = firestoreMap['gender'],
        profileImageUrl = firestoreMap['profileImageUrl'],
        points = firestoreMap['points'],
        userId = firestoreMap['userId'],
        accountCreationDate = firestoreMap['accountCreationDate'].toDate();
}
