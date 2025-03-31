import 'package:flutter/material.dart';

class MoodCard extends StatelessWidget {
  final Color color;
  final String mood;
  final String time; // Represents the date
  final String? note;
  final VoidCallback onEditPressed; // Callback for edit/delete button

  const MoodCard({
    super.key,
    required this.color,
    required this.mood,
    required this.time,
    this.note,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black26,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, radius: 15),
                const SizedBox(width: 10),
                Text(
                  mood,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(time, style: TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 10),
            if (note != null) ...[
              Text(
                "Note: $note",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onEditPressed,
                icon: const Icon(Icons.edit, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
