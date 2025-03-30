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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["😃", "😊", "😐", "😞", "😢"].map((emoji) {
              return GestureDetector(
                onTap: () => setState(() => selectedMood = emoji),
                child: CircleAvatar(
                  backgroundColor: selectedMood == emoji ? Colors.blue : Colors.grey,
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Add Activities"),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Add a note",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                onPressed: () {},
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
