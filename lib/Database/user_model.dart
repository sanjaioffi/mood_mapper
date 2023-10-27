import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String phoneNumber;
  String loginPassword;
  String username;
  int score;
  int age;
  Timestamp createdOn;
  List<dynamic> friends;
  List<dynamic> requests;

  User({
    required this.uid,
    required this.createdOn,
    required this.phoneNumber,
    required this.loginPassword,
    required this.username,
    required this.score,
    required this.friends,
    required this.requests,
    required this.age,

  });
}
