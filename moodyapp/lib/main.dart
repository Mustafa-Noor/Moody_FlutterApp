import 'package:flutter/material.dart';
import 'package:moodyapp/UI/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/signIn_page.dart';
import 'UI/mainPage.dart';
import 'DL/MoodDB.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Welcome(), // Default to the Welcome page
    );
  }
}
