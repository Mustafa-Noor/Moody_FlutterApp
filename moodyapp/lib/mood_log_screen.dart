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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Log")),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: const [
          MoodCard(
            emoji: "😊",
            mood: "Positive",
            time: "6:55 AM",
            activities: ["Exercise", "Good Sleep"],
            note: "Woke up feeling energetic 💪",
          ),
          MoodCard(
            emoji: "😃",
            mood: "Great",
            time: "8:36 PM",
            activities: ["Date", "Movies & TV"],
          ),
          MoodCard(
            emoji: "😐",
            mood: "Alright",
            time: "11:33 AM",
            activities: ["Sleep Early"],
          ),
          MoodCard(
            emoji: "😞",
            mood: "Bad",
            time: "10:49 AM",
            activities: ["Bad Sleep", "Party"],
            note: "Don't drink too much next time...",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openMoodDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
