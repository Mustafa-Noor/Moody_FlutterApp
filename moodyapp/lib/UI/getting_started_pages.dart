import 'package:flutter/material.dart';
import 'package:moodyapp/BL/starting_page.dart';
import 'package:moodyapp/UI/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // Import the HomeScreen class

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = GetStartedPage.load(); // Store the loaded pages

    return Scaffold(
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          GetStartedPage page = pages[index];

          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: page.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      0.0,
                    ), // Add some padding for better spacing
                    child: TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool(
                          'hasSeenOnboarding',
                          true,
                        ); // Set the flag to true
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Welcome(),
                          ), // Navigate to HomeScreen
                        );
                      },
                      child: Text(
                        'SKIP',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white, // Ensuring visibility
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    150,
                  ), // Large value to make it fully circular
                  child: Image.asset(
                    page.imagePath,
                    height: 300, // Adjust size as needed
                    width: 300, // Ensures it's a perfect circle
                    fit:
                        BoxFit
                            .cover, // Ensures the image fills the circular space
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      page.title,
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      page.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30), // Space before bottom edge
                  ],
                ),
                SizedBox(
                  height: 10, // Set a fixed height for visibility
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pages.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: index == i ? 40 : 20,
                          height: 8, // Ensure visibility
                          decoration: BoxDecoration(
                            color: index == i ? Colors.white70 : Colors.white30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
