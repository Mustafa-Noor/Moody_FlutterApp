import 'package:flutter/material.dart';

class MoodCard extends StatelessWidget {
  final String emoji;
  final String mood;
  final String time;
  final List<String> activities;
  final String? note;

  const MoodCard({
    super.key,
    required this.emoji,
    required this.mood,
    required this.time,
    required this.activities,
    this.note,
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
                Text(emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 10),
                Text(
                  mood,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(time, style: TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: activities.map((activity) {
                return Chip(
                  backgroundColor: Colors.grey[700],
                  label: Text(activity, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            if (note != null) ...[
              const SizedBox(height: 10),
              Text("Note: $note", style: const TextStyle(color: Colors.white70)),
            ],
          ],
        ),
      ),
    );
  }
}
