import 'package:flutter/material.dart';
import '../DL/MoodDB.dart';

class MoodEntryDialog extends StatefulWidget {
  final Map<String, dynamic>? existingMood; // Existing mood for editing
  final Function(Map<String, dynamic>) onSave; // Callback to save the mood

  const MoodEntryDialog({super.key, this.existingMood, required this.onSave});

  @override
  _MoodEntryDialogState createState() => _MoodEntryDialogState();
}

class _MoodEntryDialogState extends State<MoodEntryDialog> {
  late DateTime selectedDate;
  late String selectedMood;
  late Color selectedColor;
  final TextEditingController noteController = TextEditingController();

  final List<Map<String, dynamic>> moodOptions = [
    {"color": Colors.red, "mood": "Angry"},
    {"color": Colors.orange, "mood": "Excited"},
    {"color": Colors.yellow, "mood": "Happy"},
    {"color": Colors.green, "mood": "Calm"},
    {"color": Colors.blue, "mood": "Sad"},
    {"color": Colors.purple, "mood": "Tired"},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingMood != null) {
      // Pre-fill fields for editing
      selectedDate = DateTime.parse(widget.existingMood!['date']);
      selectedMood = widget.existingMood!['mood'];
      selectedColor = Color(
        int.parse(widget.existingMood!['color'], radix: 16),
      );
      noteController.text = widget.existingMood!['note'];
    } else {
      // Default values for adding a new mood
      selectedDate = DateTime.now();
      selectedMood = '';
      selectedColor = Colors.grey;
    }
  }

  void _pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) setState(() => selectedDate = newDate);
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

  Future<void> _saveMood() async {
    if (selectedMood.isEmpty) {
      _showTopSnackBar("Please select a mood!");
    } else if (noteController.text.isEmpty) {
      _showTopSnackBar("Please add a note!");
    } else if (await LocalDatabase().doesDateExist(selectedDate.toString())) {
      _showTopSnackBar("Mood for this date already exists!");
    } else if (selectedDate.isAfter(DateTime.now())) {
      _showTopSnackBar("Date cannot be in the future!");
    } else {
      widget.onSave({
        'date': selectedDate.toString(),
        'color': selectedColor.value.toRadixString(16).padLeft(8, '0'),
        'mood': selectedMood,
        'note': noteController.text,
      });
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "How are you feeling?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          // Show date picker only if adding a new mood
          if (widget.existingMood == null)
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
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          option["mood"],
                          style: const TextStyle(fontSize: 12),
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
              if (widget.existingMood != null)
                TextButton(
                  onPressed: () async {
                    // Call updateMood from LocalDatabase
                    await LocalDatabase().updateMood(
                      widget
                          .existingMood!['id'], // Pass the ID of the existing mood
                      selectedColor.value
                          .toRadixString(16)
                          .padLeft(8, '0'), // Updated color
                      selectedMood, // Updated mood
                      noteController.text, // Updated note
                    );

                    // Notify parent widget and close the dialog
                    widget.onSave({
                      'id': widget.existingMood!['id'],
                      'date': selectedDate.toString(),
                      'color': selectedColor.value
                          .toRadixString(16)
                          .padLeft(8, '0'),
                      'mood': selectedMood,
                      'note': noteController.text,
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text("Update"),
                )
              else
                ElevatedButton(onPressed: _saveMood, child: const Text("Save")),
            ],
          ),
        ],
      ),
    );
  }
}
