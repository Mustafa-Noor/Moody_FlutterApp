import 'package:flutter/material.dart';

class MoodEntryDialog extends StatefulWidget {
  const MoodEntryDialog({super.key});

  @override
  _MoodEntryDialogState createState() => _MoodEntryDialogState();
}

class _MoodEntryDialogState extends State<MoodEntryDialog> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedMood = "Alright"; // Default mood
  Color selectedColor = Colors.grey; // Default color

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

  void _pickTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (newTime != null) setState(() => selectedTime = newTime);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text("${selectedDate.toLocal()}".split(' ')[0]),
              ),
              TextButton.icon(
                onPressed: _pickTime,
                icon: const Icon(Icons.access_time),
                label: Text(selectedTime.format(context)),
              ),
            ],
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white, // Label text in white
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 15),
          TextField(
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
                onPressed: () {
                  // Save logic here
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
