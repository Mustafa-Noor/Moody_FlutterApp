import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'getting_started_pages.dart'; // Import the GettingStarted screen
import 'mood_log_screen.dart';
import 'chart.dart'; // Import the MoodBarChartPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: hasSeenOnboarding ? const HomeScreen() : const GettingStarted(),
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
