import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/getx/user_controller.dart';
import 'package:random_avatar/random_avatar.dart';

// show online users to get quick response for emeregeency

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var cordinates = [];

    int Badges = 5; // Replace with actual following count
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        // leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'User Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            getUserDetailsStream(Get.find<UserController>().user.value!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          } else {
            if (snapshot.hasData) {
              var userDetails = snapshot.data!.data();

              String name = userDetails!['username'] ?? '';
              int score = userDetails['score'] ?? '';
              int age = userDetails['age'] ?? '';
              String phoneNo = userDetails['phoneNumber'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: RandomAvatar(
                            score.toString(),
                            height: 100,
                            width: 100,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${name}',
                          style: TextStyle(
                              color: AppColor.whatsAppTealGreen,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        // _authController.authorizedUser != null
                        //     ? Text(
                        //         'Authorized User: ${_authController.authorizedUser!.uid}')
                        //     : Text('User not authorized.'),
                        SizedBox(
                          height: 5,
                        ),

                        // Text(
                        //   'Mobile Number: +91 ${phoneNo}',
                        //   style: TextStyle(
                        //       color: AppColor.whatsAppTealGreen,
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.w500),
                        // ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          'Age: $age Years',
                          style: TextStyle(
                              color: AppColor.whatsAppTealGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 3,
                        ),

                        Text(
                          'Current Score : $score',
                          style: TextStyle(
                              color: AppColor.whatsAppTealGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Usage Streaks',
                                style: TextStyle(fontSize: 20))),
                        SizedBox(
                          height: 20,
                        ),

                        HeatMap(
                          datasets: {
                            DateTime(2023, 10, 6): 3,
                            DateTime(2023, 10, 7): 7,
                            DateTime(2023, 10, 8): 10,
                            DateTime(2023, 10, 9): 13,
                            DateTime(2023, 10, 13): 6,
                          },
                          colorMode: ColorMode.opacity,
                          showText: false,
                          scrollable: true,
                          colorsets: {
                            3: Colors.orange,
                            5: Colors.yellow,
                            7: Colors.green,
                            9: Colors.blue,
                            11: Colors.indigo,
                            13: Colors.purple,
                          },
                          onClick: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value.toString())));
                          },
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Badges Earned',
                                style: TextStyle(fontSize: 20))),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 200,
                          child: GridView(
                              children: [
                                for (var i = 1; i < 5; i++)
                                  CircleAvatar(
                                      radius: 10,
                                      backgroundImage: AssetImage(
                                        'assets/images/$i.png',
                                      )),
                              ],
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.2,
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('User not found'),
              );
            }
          }
        },
      ),
    ));
  }

  // Function to get the user details from Firestore based on the user ID
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDetailsStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }
}
