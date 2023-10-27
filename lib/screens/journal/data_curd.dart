import 'package:shared_preferences/shared_preferences.dart';
import 'data_model.dart';


Future<void> saveDailyEntry(DailyEntry entry) async {
  final prefs = await SharedPreferences.getInstance();
  final data = entry.date.toString();
  final inputTexts = entry.inputTexts.join("##");
  final moodTexts = entry.moodTexts.join("##");
  prefs.setString(data, '$inputTexts||$moodTexts');
}


Future<DailyEntry?> getDailyEntry(DateTime date) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString(date.toString());

  if (data != null) {
    final parts = data.split("||");
    final inputTexts = parts[0].split("##");
    final moodTexts = parts[1].split("##");

    return DailyEntry(
      date: date,
      inputTexts: inputTexts,
      moodTexts: moodTexts,
    );
  } else {
    return null;
  }
}
