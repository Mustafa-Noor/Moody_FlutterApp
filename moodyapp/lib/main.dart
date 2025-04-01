import 'package:flutter/material.dart';
import 'mood_log_screen.dart';
import 'chart.dart'; // Import the MoodBarChartPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(), // Set HomeScreen as the initial screen
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected tab

  // List of screens for navigation
  final List<Widget> _screens = [
    MoodLogScreen(), // Mood Log Screen
    MoodBarChartPage(), // Mood Chart Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Mood Log"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Chart"),
        ],
      ),
    );
  }
}
