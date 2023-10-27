import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_avatar/random_avatar.dart';

class LeaderBoardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Leaderboard(),
    );
  }
}

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('score', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final username = user['username'];
            final score = user['score'];

            return Column(
              children: [
                ListTile(
                  leading: RandomAvatar(
                    score.toString(),
                    height: 50,
                    width: 52,
                  ),
                  title: Text(username),
                  subtitle: Text('Score: $score'),
                  trailing: Text('Rank: ${index + 1}'),
                ),
                Divider()
              ],
            );
          },
        );
      },
    );
  }
}
