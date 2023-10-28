import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/screens/onboarding/login_page.dart';
import 'package:mood_tracker/screens/onboarding/signup_page_2.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController inviteCodeController = TextEditingController();

  String verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String smscode = "";
  bool loading = false;

  _signInWithMobileNumber() async {
    UserCredential _credential;
    User user;
    try {
      print('+91' + phoneController.text.toString().trim());
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91' + phoneController.text.toString().trim(),
          verificationCompleted: (PhoneAuthCredential authCredential) async {
            setState(() {
              loading = false;
            });
            await _auth.signInWithCredential(authCredential).then((value) {
              Get.snackbar("Success", "Phone number verified",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade800,
                  colorText: Colors.white);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage2(
                            phoneNumber: phoneController.text.toString().trim(),
                          )));
            });
          },
          verificationFailed: ((error) {
            print(error);
          }),
          codeSent: (String verificationId, [int? forceResendingToken]) {
            setState(() {
              this.verificationId = verificationId;
            });
            Get.snackbar("Success", "OTP sent",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.shade800,
                colorText: Colors.white);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              this.verificationId = verificationId;
            });
          },
          timeout: Duration(seconds: 45));
    } catch (e) {}
  }

  // Enable the button again after 60 seconds

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
                child: Text('New User',
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
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      // maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefix: Text('+91 '),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        prefixIcon: Icon(Icons.phone, color: Colors.grey),
                        hintText: 'Phone number',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool documentExists = await isDocumentExists(
                            'users', phoneController.text.toString().trim());
                        if (documentExists) {
                          Get.snackbar("Error", "Phone number already exists",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red.shade800,
                              colorText: Colors.white);
                          showMobileRegisteredDialog(context);
                        } else {
                          setState(() {
                            loading = true;
                          });
                          showLoadingDialog(
                              context, 'Sending OTP to your phone number');
                          // Simulate a time-consuming task
                          await Future.delayed(Duration(seconds: 2));

                          // Close the dialog when the task is done
                          Navigator.of(context).pop();
                          _signInWithMobileNumber();
                        }
                      },
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.teaGreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: LinearProgressIndicator(),
                    ),
                    Text(
                      'Please wait...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : SizedBox(),
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
                // maxLength: 10,
                keyboardType: TextInputType.phone,
                controller: otpController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
                  hintText: 'OTP',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                FirebaseAuth auth = FirebaseAuth.instance;

                smscode = otpController.text;
                print(verificationId);
                print(smscode);
                PhoneAuthCredential _credential = PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: smscode);
                auth.signInWithCredential(_credential).then((result) {
                  if (result != null) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpPage2(
                                  phoneNumber:
                                      phoneController.text.toString().trim(),
                                )));
                  }
                }).catchError((e) {
                  print(e);
                });
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
                    'Next',
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

  void showMobileRegisteredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mobile Number Already Registered'),
          content:
              Text('This mobile number is already registered. Please log in.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Navigate to the login page or any other page as needed
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return LoginPage();
                }));
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> isDocumentExists(
      String collectionPath, String documentId) async {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    final DocumentSnapshot docSnapshot = await docRef.get();
    return docSnapshot.exists;
  }

  Future<void> showLoadingDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(), // Loading spinner
              SizedBox(height: 16),
              Text(message), // Loading message
            ],
          ),
        );
      },
    );
  }

  Future<void> verifyOTP(
      String verificationId, String otp, Function(User) onVerified) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = authResult.user;

      if (user != null) {
        // OTP verification successful
        onVerified(user);
      } else {
        // Handle verification failure
        print('OTP verification failed');
      }
    } catch (e) {
      // Handle any exceptions
      print(e.toString());
    }
  }
}

class TextFieldWithIcon extends StatelessWidget {
  final IconData icon;
  final String hintText;

  const TextFieldWithIcon(
      {super.key, required this.icon, required this.hintText});

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
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            prefixIcon: Icon(icon, color: Colors.grey),
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
