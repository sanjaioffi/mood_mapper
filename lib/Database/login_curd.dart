import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tracker/getx/user_controller.dart';
import 'package:mood_tracker/main_screen.dart';
import 'package:mood_tracker/screens/home/stt.dart';
import 'package:mood_tracker/stt_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../getx/uid_controller.dart';

Future<void> verifyPassword(String userId, String password) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    // Reference the user's document by their ID
    DocumentReference userRef = _firestore.collection('users').doc(userId);

    // Fetch the user's document
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Get the stored hashed password from the document
      Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
      String storedPassword = data['loginPassword'];

      // Compare the stored password with the provided password
      print(password);
      print(storedPassword);
      bool isPasswordCorrect = compareHashedPassword(password, storedPassword);

      print(isPasswordCorrect);
      if (isPasswordCorrect) {
        Get.snackbar('Success', 'Login successful',
            backgroundColor: Colors.green.shade800,
            snackPosition: SnackPosition.TOP);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('uid', userId);
        Get.find<UidController>().setUid(userId);
        Get.find<UserController>().fetchUserData(userId);
        Get.offAll(() => MainScreen());
      }
    } else {
      // User document not found
      Get.snackbar('Error', 'User document not found',
          backgroundColor: Colors.green.shade800,
          snackPosition: SnackPosition.TOP);
    }
  } catch (e) {
    // An error occurred
    Get.snackbar('Error', 'An error occurred',
        backgroundColor: Colors.green.shade800,
        snackPosition: SnackPosition.TOP);
  }
}

bool compareHashedPassword(String inputPassword, String hashedPassword) {
  return inputPassword == hashedPassword;
}
