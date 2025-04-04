import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moodyapp/main.dart';
import 'package:moodyapp/UI/mainPage.dart';
import 'package:moodyapp/UI/welcome.dart';

void main() {
  setUp(() async {
    // Mock SharedPreferences for the test
    SharedPreferences.setMockInitialValues({
      'isLoggedIn': false, // Default value for isLoggedIn
      'userIndex': -1, // Default value for userIndex
    });
  });

  testWidgets('App starts with Welcome page when not logged in', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp(isLoggedIn: false, userIndex: -1));

    // Verify that the Welcome page is displayed
    expect(find.byType(Welcome), findsOneWidget);
  });

  testWidgets('App starts with Mainpage when logged in', (
    WidgetTester tester,
  ) async {
    // Mock SharedPreferences for logged-in state
    SharedPreferences.setMockInitialValues({
      'isLoggedIn': true,
      'userIndex': 1,
    });

    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp(isLoggedIn: true, userIndex: 1));

    // Verify that the Mainpage is displayed
    expect(find.byType(Mainpage), findsOneWidget);
  });
}
