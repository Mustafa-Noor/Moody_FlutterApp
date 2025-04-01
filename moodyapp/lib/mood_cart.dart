import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class MoodCard extends StatelessWidget {
  final Color color;
  final String mood;
  final String time; // Represents the date in YYYY-MM-DD format
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

  String _formatDate(String date) {
    // Parse the date string and format it in English style
    final parsedDate = DateTime.parse(date);
    return DateFormat(
      'MMMM d, yyyy',
    ).format(parsedDate); // Example: April 1, 2025
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: color, width: 2), // Border with circle color
      ),
      color: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 20, // Increased circle size
                ),
                const SizedBox(width: 10),
                Text(
                  mood,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color, // Mood text matches circle color
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(time), // Format the date
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (note != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "Note: ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Bold "Note:"
                          color: Colors.white70,
                        ),
                        children: [
                          TextSpan(
                            text: note,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onEditPressed,
                    icon: const Icon(Icons.edit, color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
