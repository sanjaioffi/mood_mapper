import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/Database/user_curd.dart';
import 'package:mood_tracker/Database/user_model.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/getx/user_controller.dart';
import 'package:mood_tracker/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../getx/uid_controller.dart';

class SignUpPage2 extends StatelessWidget {
  SignUpPage2({
    super.key,
    required this.phoneNumber,
  });
  String phoneNumber;

  TextEditingController loginPassword = TextEditingController();
  TextEditingController withdrawalPassword = TextEditingController();
  TextEditingController confirmWithdrawalPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('User Details',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 10),
          Lottie.asset('assets/images/register.json'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  hintText: 'Enter Your Name',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: age,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  prefixIcon: Icon(Icons.person_2, color: Colors.grey),
                  hintText: 'Enter Your Age',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          PasswordField(
            hintText: 'Enter login password',
            controller: loginPassword,
          ),
          PasswordField(
            hintText: 'confirm login password',
            controller: loginPassword,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                print(
                    'Update started....................................................................................................................................................');
                DatabaseService().updateUserData(User(
                    createdOn: Timestamp.now(),
                    uid: phoneNumber,
                    phoneNumber: phoneNumber,
                    loginPassword: loginPassword.text,
                    username: name.text,
                    score: 0,
                    age: int.parse(age.text),
                    friends: [],
                    requests: []));
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('uid', phoneNumber);
                Get.find<UidController>().setUid(phoneNumber);
                Get.find<UserController>().fetchUserData(phoneNumber);

                print(
                    'Update successfully....................................................................................................................................................');
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return MainScreen();
                }));
              },
              child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.whatsAppTealGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    ));
  }
}

class PasswordField extends StatefulWidget {
  final String hintText;
  TextEditingController controller;

  PasswordField({super.key, required this.hintText, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 3.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            hintText: widget.hintText,
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
