import 'package:flutter/material.dart';

import 'package:mood_tracker/firebase_options.dart';
import 'package:mood_tracker/getx/uid_controller.dart';
import 'package:mood_tracker/getx/user_controller.dart';
import 'package:mood_tracker/main_screen.dart';
import 'package:mood_tracker/screens/home/linechart.dart';
import 'package:mood_tracker/screens/home/stt.dart';
import 'package:mood_tracker/screens/onboarding/onboarding_page.dart';
import 'package:mood_tracker/screens/onboarding/signup_page.dart';
import 'package:mood_tracker/stt_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
// import 'package:money_view/getx/uid_controller.dart';
// import 'package:money_view/getx/user_controller.dart';
// import 'package:money_view/screens/mianpages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Check if the user's UID is saved in shared preferences
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid');
  Get.put<UidController>(UidController());
  Get.put<UserController>(UserController());

  runApp(MyApp(uid: uid));
}

class MyApp extends StatelessWidget {
  final String? uid;

  const MyApp({super.key, required this.uid});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (uid != null) {
      Get.find<UidController>().setUid(uid!);
      Get.find<UserController>().fetchUserData(uid!);
    }
    return GetMaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: uid == null ? const OnboardingPage() : MainScreen(),
    );
  }
}
