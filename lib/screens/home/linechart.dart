import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlyScoresChart extends StatefulWidget {
  @override
  _YearlyScoresChartState createState() => _YearlyScoresChartState();
}

class _YearlyScoresChartState extends State<YearlyScoresChart> {
  DateTime startDate = DateTime(2023, 5, 15);
  DateTime endDate = DateTime(2023, 8, 15);

  void updateDateRange(int numberOfMonths) {
    setState(() {
      startDate = startDate.add(Duration(days: numberOfMonths * 30));
      endDate = endDate.add(Duration(days: numberOfMonths * 30));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    updateDateRange(-1); // Move one month back
                  },
                ),
                Text(
                  DateFormat('dd-MM-yyyy').format(startDate) +
                      " to " +
                      DateFormat('dd-MM-yyyy').format(endDate),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    updateDateRange(1); // Move one month forward
                  },
                ),
              ],
            ),
          ),
          Container(
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(),
              series: <ChartSeries>[
                LineSeries<WeekData, DateTime>(
                  dataSource: generateSampleDataForYear(startDate, endDate),
                  xValueMapper: (WeekData week, _) => week.date,
                  yValueMapper: (WeekData week, _) => week.score,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeekData {
  final DateTime date;
  final double score;

  WeekData(this.date, this.score);
}

List<WeekData> generateSampleDataForYear(DateTime startDate, DateTime endDate) {
  // Generate sample data for the entire year
  List<WeekData> data = [];
  for (DateTime date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
      date = date.add(Duration(days: 7))) {
    // Simulate random scores between 0 and 100
    double score = (date.day % 5) * 20.0; // Replace with your actual data
    data.add(WeekData(date, score));
  }

  return data;
}



// class WeeklyScoresChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: SfCartesianChart(
//         primaryXAxis: CategoryAxis(),
//         primaryYAxis: NumericAxis(),
//         series: <ChartSeries>[
//           LineSeries<WeekData, String>(
//             dataSource: generateSampleDataForWeek(),
//             xValueMapper: (WeekData week, _) => week.day,
//             yValueMapper: (WeekData week, _) => week.score,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WeekData {
//   final String day;
//   final double score;

//   WeekData(this.day, this.score);
// }

// List<WeekData> generateSampleDataForWeek() {
//   // Generate sample data for one week
//   List<WeekData> data = [
//     WeekData('Mon', 85),
//     WeekData('Tue', 70),
//     WeekData('Wed', 95),
//     WeekData('Thu', 60),
//     WeekData('Fri', 80),
//     WeekData('Sat', 90),
//     WeekData('Sun', 75),
//   ];

//   return data;
// }
