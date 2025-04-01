import 'package:flutter/material.dart';
import 'LocalDb.dart';

class MoodEntryDialog extends StatefulWidget {
  const MoodEntryDialog({super.key});

  @override
  _MoodEntryDialogState createState() => _MoodEntryDialogState();
}

class _MoodEntryDialogState extends State<MoodEntryDialog> {
  DateTime selectedDate = DateTime.now();
  String selectedMood = ''; // Default mood
  Color selectedColor = Colors.grey; // Default color
  final TextEditingController noteController = TextEditingController();

  final List<Map<String, dynamic>> moodOptions = [
    {"color": Colors.red, "mood": "Angry"},
    {"color": Colors.orange, "mood": "Excited"},
    {"color": Colors.yellow, "mood": "Happy"},
    {"color": Colors.green, "mood": "Calm"},
    {"color": Colors.blue, "mood": "Sad"},
    {"color": Colors.purple, "mood": "Tired"},
  ];

  void _pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) setState(() => selectedDate = newDate);
  }

  void checkMoods() async {
    final moods = await LocalDatabase().getMoods();
    print("Current moods in database: $moods");
  }

  void _showTopSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 200,
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void validateInputs() {
    if (selectedMood.isEmpty) {
      _showTopSnackBar("Please select a mood!");
    } else if (noteController.text.isEmpty) {
      _showTopSnackBar("Please add a note!");
    } else {
      String colorHex = selectedColor.value.toRadixString(16).padLeft(8, '0');
      LocalDatabase().addMood(
        selectedDate.toString(),
        colorHex,
        selectedMood, // Adding mood separately
        noteController.text, // Keeping note separate
      );
      checkMoods(); // Check moods after adding
      _showTopSnackBar("Mood saved successfully!");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: mediaQuery.viewInsets.bottom + 20, // Adjust for keyboard
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "How are you feeling?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text("${selectedDate.toLocal()}".split(' ')[0]),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children:
                  moodOptions.map((option) {
                    return GestureDetector(
                      onTap:
                          () => setState(() {
                            selectedMood = option["mood"];
                            selectedColor = option["color"];
                          }),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: option["color"],
                            radius: 20,
                            child:
                                selectedMood == option["mood"]
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            option["mood"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: "Add a note",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: validateInputs, // Call validateInputs method

                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
