import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/getx/user_controller.dart';


// show online users to get quick response for emeregeency

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        stream: getUserDetailsStream(Get.find<UserController>().user.value!.uid),
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
              String address = userDetails['address'] ?? '';
              String phoneNo = userDetails['phoneNo'] ?? '';
              List complaints = userDetails['complaints'] ?? [];
              String dob = userDetails['dob'] ?? '';
              String bloodGroup = userDetails['bloodGroup'] ?? '';
              String lastBloodDonated = userDetails['lastBloodDonated'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        
                        SizedBox(
                          width: 20,
                        ),
                        // Image.asset(
                        //   'assets/icons/social_activist.png',
                        //   width: 70,
                        //   height: 70,
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: AppColor.whatsAppTealGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // _authController.authorizedUser != null
                    //     ? Text(
                    //         'Authorized User: ${_authController.authorizedUser!.uid}')
                    //     : Text('User not authorized.'),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Emergency Informations',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Emergency contact: ${phoneNo}',
                      style: TextStyle(
                          color: AppColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Blood Group: $bloodGroup',
                          style: const TextStyle(
                              color: AppColor.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '   (Last Donated: $lastBloodDonated)',
                          style: const TextStyle(
                              color: AppColor.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      'Emergency address : $address',
                      style: TextStyle(
                          color: AppColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 3,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Complaints',
                              style: TextStyle(
                                  color: AppColor.whatsAppTealGreen,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                        ),
                      ),
                    ),

                   

                    ListView.builder(
                      itemCount: cordinates.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                          "Status : ${statusMap[cordinates[index]]}",
                        ));
                      },
                    ),
                  ],
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

const statusMap = {
  0: "Submmited",
  1: "Reviewed",
  2: "IN progress",
  3: "Resolved",
  4: "Suspended",
};
