import 'package:flutter/material.dart';
import 'package:moodyapp/UI/welcome.dart';
import 'mood_log_screen.dart';
import 'chart.dart'; // Import the MoodBarChartPage
import 'signIn_page.dart';
import '../DL/UserDB.dart'; // Import the UserDatabase class

class Mainpage extends StatefulWidget {
  final int userIndex; // Index of the logged-in user

  const Mainpage({super.key, required this.userIndex});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0; // Track the selected tab

  Future<String?> getusernamefromindex(int index) {
    // Replace this with actual logic to fetch the username from the user index
    final userDatabase =
        UserDatabase.instance; // Use the appropriate named constructor
    return userDatabase.getUsernameFromIndex(index);
  }

  // List of screens for navigation
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MoodLogScreen(userIndex: widget.userIndex), // Mood Log Screen
      MoodBarChartPage(userIndex: widget.userIndex), // Mood Chart Screen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });
  }

  void _logOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Welcome(),
      ), // Navigate back to LoginPage
    );
  }

  void _changePassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                  ),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "New Password"),
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm New Password",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Change"),
              onPressed: () async {
                final currentPassword = currentPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();

                if (newPassword != confirmPassword) {
                  _showError("Error", "New passwords do not match.");
                  return;
                }

                if (newPassword.length < 6) {
                  _showError(
                    "Error",
                    "Password must be at least 6 characters long.",
                  );
                  return;
                }

                final userDatabase = UserDatabase.instance;

                // Fetch the username for the current user
                final username = await userDatabase.getUsernameFromIndex(
                  widget.userIndex,
                );
                if (username == null) {
                  _showError("Error", "User not found.");
                  return;
                }

                // Validate the current password
                final isValid = await userDatabase.checkUsernameAndPassword(
                  username,
                  currentPassword,
                );

                if (!isValid) {
                  _showError("Error", "Current password is incorrect.");
                  return;
                }

                // Update the password
                try {
                  await userDatabase.changePasswordById(
                    widget.userIndex,
                    newPassword,
                  );
                  Navigator.of(context).pop();
                  _showError("Success", "Password changed successfully.");
                } catch (e) {
                  _showError(
                    "Error",
                    "Failed to change password. Please try again.",
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showError(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? "Mood Log" : "Mood Count", // Dynamic title
        ),
        backgroundColor: Colors.black87,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 200, // Set the desired height
              child: Container(
                decoration: const BoxDecoration(color: Colors.deepPurple),
                child: FutureBuilder<String?>(
                  future: getusernamefromindex(widget.userIndex),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const Center(
                        child: Text(
                          "Hello, User",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Hello, ${snapshot.data}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Change Password"),
              onTap: _changePassword, // Call the change password method
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: _logOut, // Call the log out method
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Log"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Chart"),
        ],
      ),
    );
  }
}
