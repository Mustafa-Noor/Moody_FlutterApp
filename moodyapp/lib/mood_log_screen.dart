import 'package:flutter/material.dart';
import 'mood_cart.dart';
import 'mood_entry_dialog.dart';

class MoodLogScreen extends StatelessWidget {
  const MoodLogScreen({super.key});

  void _openMoodDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const MoodEntryDialog(),
    );
  }

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose an Action"),
          content: const Text("Would you like to edit or delete this entry?"),
          actions: [
            TextButton(
              onPressed: () {
                // Add delete logic here
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                // Add edit logic here
                Navigator.pop(context);
              },
              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Log")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                MoodCard(
                  color: Colors.yellow,
                  mood: "Positive",
                  time: "2025-03-28", // Date
                  note: "Woke up feeling energetic 💪",
                  onEditPressed: () {
                    _showActionDialog(context);
                  },
                ),
                MoodCard(
                  color: Colors.orange,
                  mood: "Great",
                  time: "2025-03-27", // Date
                  note: "Had a wonderful evening with friends.",
                  onEditPressed: () {
                    _showActionDialog(context);
                  },
                ),
                MoodCard(
                  color: Colors.grey,
                  mood: "Alright",
                  time: "2025-03-26", // Date
                  note: "A regular day, nothing special.",
                  onEditPressed: () {
                    _showActionDialog(context);
                  },
                ),
                MoodCard(
                  color: Colors.blue,
                  mood: "Bad",
                  time: "2025-03-25", // Date
                  note: "Feeling down due to lack of sleep.",
                  onEditPressed: () {
                    _showActionDialog(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Mood Log Screen (current screen)
                },
                icon: const Icon(Icons.list),
                label: const Text("Mood Log"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Chart Screen
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text("Chart"),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openMoodDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
