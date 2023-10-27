import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/app_colors.dart';
import 'package:mood_tracker/getx/user_controller.dart';
import 'package:mood_tracker/screens/home/mood_chart.dart';
import 'package:mood_tracker/screens/home/quotes.dart';
import 'package:mood_tracker/screens/home/linechart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(formatDate(DateTime.now()),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      'Hello ${Get.find<UserController>().user.value?.username ?? ''} 😊',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.winterGreen)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    motivationalQuotes[
                        Random().nextInt(motivationalQuotes.length)],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColor.whatsAppTealGreen)),
              ),
              SizedBox(height: 20),
              Divider(thickness: .5),
              SizedBox(height: 20),
              Text(
                "Your Mood Tracker History",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.winterGreen),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Values in the charts are used for demonstration purpose',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: AppColor.grey)),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Heat Maps', style: TextStyle(fontSize: 20))),
              ),
              SizedBox(
                height: 20,
              ),
              HeatMap(
                datasets: {
                  DateTime(2023, 10, 6): 3,
                  DateTime(2023, 10, 7): 7,
                  DateTime(2023, 10, 8): 10,
                  DateTime(2023, 10, 9): 13,
                  DateTime(2023, 10, 13): 6,
                },
                colorMode: ColorMode.opacity,
                showText: false,
                scrollable: true,
                colorsets: {
                  1: AppColor.whatsAppTealGreen,
                  3: Colors.orange,
                  5: Colors.yellow,
                  7: Colors.green,
                  9: Colors.blue,
                  11: Colors.indigo,
                  13: Colors.purple,
                },
                onClick: (value) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.toString())));
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Line Chart', style: TextStyle(fontSize: 20))),
              ),
              YearlyScoresChart(),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Pie Chart', style: TextStyle(fontSize: 20))),
              ),
              MoodPieChart(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    final DateFormat dayFormat = DateFormat('EEEE'); // Day in letters
    final DateFormat dateFormat = DateFormat('d'); // Date in numbers
    final DateFormat monthFormat = DateFormat('MMMM'); // Month in letters

    final String day = dayFormat.format(dateTime);
    final String date = dateFormat.format(dateTime);
    final String month = monthFormat.format(dateTime);

    return '$day, $date $month';
  }
}
