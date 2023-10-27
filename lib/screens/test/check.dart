import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mood_tracker/getx/user_controller.dart';

class MoodEntry {
  final String text;
  final String analyzedMood;
  final DateTime date;

  MoodEntry({
    required this.text,
    required this.analyzedMood,
    required this.date,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mood Entries'),
        ),
        body: MoodEntriesPage(),
      ),
    );
  }
}

class MoodEntryService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addMoodEntry(String userId, MoodEntry entry) async {
    final userDoc = usersCollection.doc(userId);

    // Create a subcollection named 'moodEntries' under the user's document
    final moodEntriesCollection = userDoc.collection('moodEntries');

    await moodEntriesCollection.add({
      'text': entry.text,
      'analyzedMood': entry.analyzedMood,
      'date': entry.date,
    });
  }

  Stream<QuerySnapshot> getMoodEntriesStream(String userId) {
    final moodEntriesCollection = usersCollection.doc(userId).collection('moodEntries');

    return moodEntriesCollection.orderBy('date', descending: true).snapshots();
  }
}

class MoodEntriesPage extends StatelessWidget {
  final MoodEntryService moodEntryService = MoodEntryService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: moodEntryService.getMoodEntriesStream( Get.find<UserController>().user.value!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final entries = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return MoodEntry(
            text: data['text'],
            analyzedMood: data['analyzedMood'],
            date: data['date'].toDate(),
          );
        }).toList();

        // Group entries by date
        final Map<DateTime, List<MoodEntry>> entriesByDate = {};

        for (var entry in entries) {
          final date = entry.date;
          if (!entriesByDate.containsKey(date)) {
            entriesByDate[date] = [];
          }
          entriesByDate[date]!.add(entry);
        }

        final sortedDates = entriesByDate.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final entriesForDate = entriesByDate[date];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Date: ${date.toLocal().toString()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (var entry in entriesForDate!)
                      ListTile(
                        title: Text('Text: ${entry.text}'),
                        subtitle: Text('Analyzed Mood: ${entry.analyzedMood}'),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
