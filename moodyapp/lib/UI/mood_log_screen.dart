import 'package:flutter/material.dart';
import '../BL/mood_card.dart';
import 'mood_entry_dialog.dart';
import '../DL/MoodDB.dart';

class MoodLogScreen extends StatefulWidget {
  final int userIndex; // User index to associate moods with a specific user
  const MoodLogScreen({Key? key, required this.userIndex}) : super(key: key);

  @override
  _MoodLogScreenState createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  late Future<List<Map<String, dynamic>>> _moodsFuture;

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  void _loadMoods() {
    setState(() {
      _moodsFuture = LocalDatabase().getMoods(
        widget.userIndex,
      ); // Fetch moods for the user
    });
  }

  void _openMoodDialog({Map<String, dynamic>? existingMood}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder:
          (context) => MoodEntryDialog(
            userIndex: widget.userIndex, // Pass userIndex to the dialog
            existingMood: existingMood,
            onSave: (updatedMood) async {
              if (existingMood != null) {
                // Update the mood in the database
                await LocalDatabase().updateMood(
                  widget.userIndex,
                  existingMood['id'],
                  updatedMood['color'],
                  updatedMood['mood'],
                  updatedMood['note'],
                );
              } else {
                // Add a new mood
                await LocalDatabase().addMood(
                  widget.userIndex,
                  updatedMood['date'],
                  updatedMood['color'],
                  updatedMood['mood'],
                  updatedMood['note'],
                );
              }
              _loadMoods(); // Refresh the mood list
            },
          ),
    );
  }

  void _showActionDialog(BuildContext context, Map<String, dynamic> mood) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose an Action"),
          content: const Text("Would you like to edit or delete this entry?"),
          actions: [
            TextButton(
              onPressed: () async {
                await LocalDatabase().deleteMood(widget.userIndex, mood['id']);
                Navigator.pop(context);
                _loadMoods(); // Refresh after deletion
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _openMoodDialog(existingMood: mood); // Open dialog for editing
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _moodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading moods"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No mood entries yet"));
          }

          final moods = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              // Extract just the date portion (YYYY-MM-DD)
              final dateString = mood['date'].toString().split(' ')[0];

              return MoodCard(
                color: Color(int.parse(mood['color'], radix: 16)),
                mood: mood['mood'],
                time: dateString, // Now shows only the date
                note: mood['note'],
                onEditPressed: () => _showActionDialog(context, mood),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openMoodDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
