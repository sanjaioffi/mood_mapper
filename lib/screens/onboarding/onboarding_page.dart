import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/screens/onboarding/login_page.dart';
import 'package:mood_tracker/screens/onboarding/signup_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              const Text(
                'Mood Mapper',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Explore the Power of Words.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColor.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Lottie.asset('assets/images/mood-1.json'),
              const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     SizedBox(
              //       width: 80,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: const Color.fromARGB(255, 232, 241, 255),
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: const Padding(
              //               padding: EdgeInsets.all(15.0),
              //               child: Icon(
              //                 Icons.card_giftcard_outlined,
              //                 size: 30,
              //               ),
              //             ),
              //           ),
              //           const Text(
              //             'Instant Deposits',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //                 fontSize: 15, fontWeight: FontWeight.bold),
              //           )
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: 80,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: const Color.fromARGB(255, 231, 211, 255),
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: const Padding(
              //               padding: EdgeInsets.all(15.0),
              //               child: Icon(
              //                 Icons.fast_forward,
              //                 size: 30,
              //               ),
              //             ),
              //           ),
              //           const Text(
              //             'Quick Withdrawls',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //                 fontSize: 15, fontWeight: FontWeight.bold),
              //           )
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: 80,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: const Color.fromARGB(255, 255, 234, 198),
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: const Padding(
              //               padding: EdgeInsets.all(15.0),
              //               child: Icon(
              //                 Icons.security,
              //                 size: 30,
              //               ),
              //             ),
              //           ),
              //           const Text(
              //             'Trusted & Secure',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //                 fontSize: 15, fontWeight: FontWeight.bold),
              //           )
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const SignUpPage();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return const LoginPage();
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
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
