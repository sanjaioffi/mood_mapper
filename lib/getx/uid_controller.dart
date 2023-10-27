import 'package:get/get.dart';

class UidController extends GetxController {
  // Observable property to store the user's UID
  RxString uid = ''.obs;

  // Method to set the UID
  void setUid(String newUid) {
    uid.value = newUid;
  }
}
