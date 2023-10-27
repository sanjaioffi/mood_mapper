import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_tracker/Database/user_model.dart';


class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Update user data
  Future<void> updateUserData(User user) async {
    return await userCollection.doc(user.uid).set({
      
      'uid': user.uid,
      'createdOn': user.createdOn,
      'phoneNumber': user.phoneNumber,
      'loginPassword': user.loginPassword,
      'username': user.username,
      'score': user.score,
      'age': user.age,
      'friends': user.friends,
      'requests': user.requests,
      
 
    });
  }

  // Get user data
  Future<User?> getUserData(String uid) async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    if (doc.exists) {
      return User(
        createdOn: doc['createdOn'],

        uid: uid,
        phoneNumber: doc['phoneNumber'],
        loginPassword: doc['loginPassword'],
        username: doc['username'],
        age: doc['age'],
        score: doc['score'],
        friends: doc['friends'],
        requests: doc['requests'],
      );
    } else {
      return null;
    }
  }

  
  
}
