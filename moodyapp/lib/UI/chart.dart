import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../DL/MoodDB.dart';

class MoodBarChartPage extends StatefulWidget {
  final int userIndex;

  const MoodBarChartPage({Key? key, required this.userIndex}) : super(key: key);

  @override
  _MoodBarChartPageState createState() => _MoodBarChartPageState();
}

DateTime? _customStartDate;
DateTime? _customEndDate;

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

  List<String> getDateRange({required int days}) {
    final today = DateTime.now();
    return List.generate(days, (index) {
      final date = today.subtract(Duration(days: days - index - 1));
      return DateFormat('yyyy-MM-dd').format(date);
    });
  }

  Future<void> _selectCustomDateRange() async {
    // Ask for Start Date
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              "Start Date",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Please select the starting date",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );

    final DateTime? start = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // Makes the picker dark themed
          child: child!,
        );
      },
    );

    if (start == null) return;

    // Ask for End Date
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              "End Date",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Please select the ending date",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.deepPurple),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );

    final DateTime? end = await showDatePicker(
      context: context,
      initialDate:
          start.add(const Duration(days: 7)).isAfter(DateTime.now())
              ? DateTime.now()
              : start.add(const Duration(days: 7)),
      firstDate: start,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );

    if (end == null) return;

    setState(() {
      _customStartDate = start;
      // Ensure that the end date is adjusted by adding one day (to include the entire last day)
      _customEndDate = end.add(const Duration(days: 1));
    });

    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    List<Map<String, dynamic>> moods = [];

    // Fetch data based on the selected view
    if (_selectedView == "Weekly") {
      moods = await _db.getLast7DaysMoods(widget.userIndex);
    } else if (_selectedView == "Monthly") {
      moods = await _db.getLast30DaysMoods(widget.userIndex);
    } else if (_selectedView == "Custom" &&
        _customStartDate != null &&
        _customEndDate != null) {
      moods = await _db.getMoodsInRange(
        widget.userIndex,
        _customStartDate!,
        _customEndDate!,
      );
    }

    List<BarChartGroupData> barGroups = [];
    List<String> dates = [];

    final fullDates = getDateRange(days: _selectedView == "Weekly" ? 7 : 30);

    for (int i = 0; i < fullDates.length; i++) {
      final date = fullDates[i];
      final moodEntry = moods.firstWhere(
        (e) => e['date'].startsWith(date),
        orElse: () => {'mood': 'No Data'},
      );

      final mood = moodEntry['mood'];
      final moodValue = _moodMap[mood] ?? 0;
      final moodColor = _moodColors[mood] ?? Colors.grey;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: moodValue.toDouble(),
              color: moodColor,
              width:
                  _selectedView == "Weekly"
                      ? 12
                      : 5, // Thinner bars for Monthly and Custom
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
    });

    if (view == "Custom") {
      _selectCustomDateRange(); // Show date pickers
    } else {
      _loadMoodData(); // Load Weekly or Monthly directly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40), // Add margin from the top
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
                      ["Weekly", "Monthly", "Custom"].map((String value) {
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
                          gridData: FlGridData(
                            show: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[800], // light grey lines
                                strokeWidth: 1,
                              );
                            },
                          ),
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
    int index = value.toInt();

    if (index < 0 || index >= _dates.length) return const SizedBox.shrink();

    final date = DateTime.tryParse(_dates[index]);
    if (date == null) return const SizedBox.shrink();

    // Monthly view: show every 3rd label
    if (_selectedView == "Monthly" && index % 3 != 0) {
      return const SizedBox.shrink();
    }

    // Custom view: show only 10 spaced labels
    if (_selectedView == "Custom") {
      int total = _dates.length;
      if (total > 10 && index % (total ~/ 10) != 0) {
        return const SizedBox.shrink();
      }
    }

    // Format: Day + Month (e.g., 02 Apr)
    String formatted = DateFormat('dd MMM').format(date);

    return Transform.rotate(
      angle: -0.5, // slight tilt for readability
      child: Text(
        formatted,
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      ),
    );
  }
}
