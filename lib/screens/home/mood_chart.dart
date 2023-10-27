import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodData {
  String mood;
  double confidence;

  MoodData(this.mood, this.confidence);
}

class MoodPieChart extends StatelessWidget {
  final List<MoodData> moodData = [
    MoodData('Sad', -8),
    MoodData('Happy', 20),
    MoodData('Angry', -10),
    MoodData('Loved', 10),
    MoodData('Scared', -10),
    MoodData('Surprised', 12),
    MoodData('Neutral', 0),
  ];

  @override
  Widget build(BuildContext context) {
    final double totalConfidence =
        moodData.fold(0, (acc, data) => acc + data.confidence.abs());
    final List<PieChartSectionData> sections = moodData.map((data) {
      final double percentage =
          (data.confidence.abs() / totalConfidence) * 100.0;
      return PieChartSectionData(
        title: '${data.mood}\n${percentage.toStringAsFixed(1)}%',
        value: data.confidence.abs(),
        color: data.confidence >= 0 ? Colors.green : Colors.red,
        radius: 150, // Make the sections larger
      );
    }).toList();

    return Center(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: PieChart(
          PieChartData(
            sections: sections,
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 0,
          ),
        ),
      ),
    );
  }
}
