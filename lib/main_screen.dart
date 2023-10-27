import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/screens/home/homepage.dart';
import 'package:mood_tracker/screens/home/stt.dart';
import 'package:mood_tracker/screens/journal/journal_page.dart';
import 'package:mood_tracker/screens/leaderboard/leaderboard_page.dart';
import 'package:mood_tracker/screens/mood_screen.dart';
import 'package:mood_tracker/screens/profile/profile_page.dart';
import 'package:mood_tracker/screens/test/check.dart';
import 'package:mood_tracker/stt_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // Properties & Variables needed

  int currentTab = 0; // to keep track of active tab index

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage(); // Our first view in viewport
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static const String API_URL =
      "https://api-inference.huggingface.co/models/bhadresh-savani/distilbert-base-uncased-emotion";
  static const Map<String, String> headers = {
    "Authorization": "Bearer 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"
  };

  Future<List<dynamic>> query(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(API_URL),
      headers: headers,
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to query the API: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen,
      floatingActionButton: FloatingActionButton(
        shape: OvalBorder(),
        backgroundColor: AppColor.whatsAppTealGreen,
        child: const Icon(Icons.add),
        onPressed: () {
          _showOptionsBottomSheet(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColor.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            const HomePage(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.home,
                            color: currentTab == 0
                                ? AppColor.whatsAppTealGreen
                                : AppColor.grey),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 13,
                            color: currentTab == 0
                                ? AppColor.whatsAppTealGreen
                                : AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            const JournalPage(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.book,
                            color: currentTab == 1
                                ? AppColor.whatsAppTealGreen
                                : AppColor.grey),
                        Text(
                          'Journal',
                          style: TextStyle(
                            fontSize: 13,
                            color: currentTab == 1
                                ? AppColor.whatsAppTealGreen
                                : AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    splashColor: Colors.transparent,
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            LeaderBoardPage(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.leaderboard,
                            color: currentTab == 2
                                ? AppColor.whatsAppTealGreen
                                : AppColor.grey),
                        Text(
                          'Leaderboard',
                          style: TextStyle(
                              fontSize: 13,
                              color: currentTab == 2
                                  ? AppColor.whatsAppTealGreen
                                  : AppColor.grey),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            ProfilePage(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person,
                            color: currentTab == 3
                                ? AppColor.whatsAppTealGreen
                                : AppColor.grey),
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 13,
                              color: currentTab == 3
                                  ? AppColor.whatsAppTealGreen
                                  : AppColor.grey),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  void _showTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('What are you feeling?'),
          content: TextField(
            maxLines: 10,
            autofocus: true,
            controller: _textFieldController,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Type something...'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Do something with the text entered in the TextField
                String enteredText = _textFieldController.text;
                print('Entered text: $enteredText');
                Navigator.pop(context);
                
                Get.to(MoodScreen(enteredText));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sentiment Analysis',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black)),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildOptionTile(Icons.text_fields, 'Use text for analysis', () {
                // Handle post a complaint action
                Navigator.pop(context);
                _showTextFieldDialog(context);
              }),
              _buildOptionTile(Icons.voice_chat, 'Use Audio for analysis', () {
                // Handle post a query action
                Navigator.pop(context);
                Get.to(sttPage());
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile(IconData iconData, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: AppColor.white,
        child: Icon(
          iconData,
          color: AppColor.grey,
          size: 24,
        ),
      ),
      title: Text(title, style: TextStyle(color: AppColor.black)),
      onTap: onTap,
    );
  }
}
