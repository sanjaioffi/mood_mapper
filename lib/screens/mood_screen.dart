import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mood_tracker/getx/user_controller.dart';
import 'package:mood_tracker/recommedations.dart';
import 'package:mood_tracker/screens/test/check.dart';

class MoodScreen extends StatelessWidget {
  final String enteredText;

  MoodScreen(this.enteredText);

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

  Future<String> deriveMood() async {
    List<dynamic> output = await query({
      "inputs": enteredText,
    });
    String mood = output[0][0]['label'];
    double confidence = output[0][0]['score'];

    if (mood == 'sadness') {
      mood = 'Sad';
      confidence = confidence * -10;
    } else if (mood == 'joy') {
      mood = 'Happy';
      confidence = confidence * 10;
    } else if (mood == 'anger') {
      mood = 'Angry';
      confidence = confidence * -10;
    } else if (mood == 'love') {
      mood = 'Loved';
      confidence = confidence * 10;
    } else if (mood == 'fear') {
      mood = 'Scared';
      confidence = confidence * -10;
    } else if (mood == 'surprise') {
      mood = 'Surprised';
      confidence = confidence * 10;
    } else if (mood == 'neutral') {
      mood = 'Neutral';
    }
    print(mood);
    MoodEntryService().addMoodEntry( Get.find<UserController>().user.value!.uid,
        MoodEntry(text: enteredText, analyzedMood: mood, date: DateTime.now()));

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // The score to add
    int scoreToAdd =
        confidence.ceil(); // Replace this with the score you want to add

    // Reference to the user's document in Firestore
    DocumentReference userRef = _firestore
        .collection('users')
        .doc(Get.find<UserController>().user.value!.uid);

    // Get the existing score from Firestore
    userRef.get().then((doc) {
      if (doc.exists) {
        // Retrieve the existing score
        int existingScore =
            doc['score'] ?? 0; // Default to 0 if score doesn't exist

        // Calculate the new score
        int newScore = existingScore + scoreToAdd;

        // Update the score field in Firestore
        userRef.update({'score': newScore}).then((value) {
          print('Score updated successfully.');
        }).catchError((error) {
          print('Error updating score: $error');
        });
      } else {
        print('User document does not exist.');
      }
    }).catchError((error) {
      print('Error getting user document: $error');
    });
    return mood;
  }

  Widget getMoodIcon(String mood) {
    switch (mood) {
      case 'Sad':
        return Lottie.asset('assets/images/sad.json', height: 500, width: 500);
      case 'Happy':
        return Lottie.asset('assets/images/happy.json');

      case 'Loved':
        return Icon(Icons.favorite, size: 48, color: Colors.pink);
      case 'Scared':
        return Icon(Icons.sentiment_very_dissatisfied,
            size: 48, color: Colors.green);
      case 'Surprised':
        return Icon(Icons.sentiment_satisfied, size: 48, color: Colors.purple);
      case 'Neutral':
        return Icon(Icons.sentiment_neutral, size: 48, color: Colors.grey);
      default:
        return Icon(Icons.sentiment_neutral, size: 48, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<String> mood = deriveMood();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FutureBuilder<String>(
            future: mood,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Display a loading indicator while waiting for the result.
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    Text('Please try again.'),
                    Center(
                      child: Lottie.asset('assets/images/error.json'),
                    ),
                  ],
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "You're feeling ${snapshot.data}",
                        style: TextStyle(fontSize: 30),
                      ),
                      getMoodIcon(snapshot.data!),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Here are some recommendations for you:",
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        height: 500,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount:
                                moodRecommendations[snapshot.data]!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.arrow_right),
                                title: Text(
                                    moodRecommendations[snapshot.data]![index]),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
