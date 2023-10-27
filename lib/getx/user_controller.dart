import 'package:get/get.dart';
import 'package:mood_tracker/Database/user_curd.dart';
import 'package:mood_tracker/Database/user_model.dart';

class UserController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

  void setUser(User newUser) {
    user.value = newUser;
  }

  User? get getUser => user.value;

  Future<void> fetchUserData(String uid) async {
    
    User? userData = await DatabaseService().getUserData(uid);
    print(userData?.age);
    if (userData != null) {
      setUser(userData);
      print('User data fetched successfully');
    }
    update();
  }
}
