import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'LocalDb.dart';

class MoodBarChartPage extends StatefulWidget {
  @override
  _MoodBarChartPageState createState() => _MoodBarChartPageState();
}

class _MoodBarChartPageState extends State<MoodBarChartPage> {
  final LocalDatabase _db = LocalDatabase();
  List<BarChartGroupData> _barGroups = [];
  List<String> _dates = [];
  String _selectedView = "Weekly"; // Default view
  final Map<String, int> _moodMap = {
    'Angry': 1,
    'Excited': 2,
    'Happy': 3,
    'Calm': 4,
    'Sad': 5,
    'Tired': 6,
  };
  final Map<String, Color> _moodColors = {
    'Angry': Colors.red,
    'Excited': Colors.orange,
    'Happy': Colors.yellow,
    'Calm': Colors.green,
    'Sad': Colors.blue,
    'Tired': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    List<Map<String, dynamic>> moods = [];

    // Fetch data based on the selected view
    if (_selectedView == "Weekly") {
      moods = await _db.getLast7DaysMoods();
    } else if (_selectedView == "Monthly") {
      moods = await _db.getLast30DaysMoods();
    }

    List<BarChartGroupData> barGroups = [];
    List<String> dates = [];

    // Generate the X-axis points and bar groups
    for (int i = 0; i < moods.length; i++) {
      final mood = moods[i]['mood'];
      final date = moods[i]['date'].split(' ')[0];
      final moodValue = _moodMap[mood] ?? 0;
      final moodColor = _moodColors[mood] ?? Colors.grey;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: moodValue.toDouble(),
              color: moodColor,
              width: 15,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      );
      dates.add(date);
    }

    setState(() {
      _barGroups = barGroups;
      _dates = dates;
    });
  }

  void _updateView(String view) {
    setState(() {
      _selectedView = view;
      _loadMoodData(); // Reload data based on the selected view
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Mood Count"),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting Weekly or Monthly view
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "View:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: _selectedView,
                  dropdownColor: Colors.black54,
                  style: const TextStyle(color: Colors.white),
                  items:
                      ["Weekly", "Monthly"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateView(newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Bar chart wrapped in a container
            Container(
              height: 300,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  _barGroups.isEmpty
                      ? const Center(
                        child: Text(
                          "No mood data available",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : BarChart(
                        BarChartData(
                          maxY:
                              6, // Maximum value on the Y-axis (based on mood levels)
                          barGroups: _barGroups,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: _leftTitleWidgets,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: _bottomTitleWidgets,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
            ),
            const SizedBox(height: 20),
            // Scale in a separate row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  _moodColors.entries.map((entry) {
                    return Column(
                      children: [
                        CircleAvatar(backgroundColor: entry.value, radius: 10),
                        const SizedBox(height: 5),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    final moodLabels = {
      1: 'Angry',
      2: 'Excited',
      3: 'Happy',
      4: 'Calm',
      5: 'Sad',
      6: 'Tired',
    };
    final moodColors = {
      1: Colors.red,
      2: Colors.orange,
      3: Colors.yellow,
      4: Colors.green,
      5: Colors.blue,
      6: Colors.purple,
    };

    if (moodLabels.containsKey(value.toInt())) {
      return CircleAvatar(
        backgroundColor: moodColors[value.toInt()] ?? Colors.transparent,
        radius: 5,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() >= 0 && value.toInt() < _dates.length) {
      return Text(
        _dates[value.toInt()],
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      );
    }
    return const Text("");
  }
}
