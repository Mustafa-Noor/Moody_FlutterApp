import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/getting_started_pages.dart'; // Import the GettingStarted screen
import 'UI/mood_log_screen.dart';
import 'UI/chart.dart'; // Import the MoodBarChartPage
import 'UI/signIn_page.dart';
import 'UI/welcome.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

//   runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
// }

// class MyApp extends StatelessWidget {
//   final bool hasSeenOnboarding;

//   const MyApp({super.key, required this.hasSeenOnboarding});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: hasSeenOnboarding ? const HomeScreen() : const GettingStarted(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0; // Track the selected tab

//   // List of screens for navigation
//   final List<Widget> _screens = [
//     MoodLogScreen(), // Mood Log Screen
//     MoodBarChartPage(), // Mood Chart Screen
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index; // Update the selected tab index
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex], // Display the selected screen
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Colors.black87,
//         selectedItemColor: Colors.deepPurple,
//         unselectedItemColor: Colors.white70,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: "Mood Log"),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Chart"),
//         ],
//       ),
//     );
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Welcome(); // Directly show the SigninPage for testing
  }
}
