import 'package:flutter/material.dart';
import 'package:moodyapp/UI/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/signIn_page.dart';
import 'UI/mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final int userIndex = prefs.getInt('userIndex') ?? -1;

  runApp(MyApp(isLoggedIn: isLoggedIn, userIndex: userIndex));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final int userIndex;

  const MyApp({super.key, required this.isLoggedIn, required this.userIndex});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:
          isLoggedIn
              ? Mainpage(
                userIndex: userIndex,
              ) // Navigate to Mainpage if logged in
              : Welcome(),
    );
  }
}
