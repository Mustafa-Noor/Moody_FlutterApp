import 'package:flutter/material.dart';

class GetStartedPage {
  final String imagePath;
  final String title;
  final String description;
  final Color backgroundColor; // Added color property

  GetStartedPage({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });

  // Function to load onboarding data
  static List<GetStartedPage> load() {
    return [
      GetStartedPage(
        imagePath: 'images/note.avif',
        title: 'Take Notes',
        description: 'Write down your thoughts and track your emotions daily.',
        backgroundColor: Colors.blue.shade900, // Darker blue // Unique color for each page
      ),
      GetStartedPage(
        imagePath: 'images/mood.avif',
        title: 'Add Your Mood',
        description: 'Choose your mood and reflect on your feelings.',
        backgroundColor: Colors.purple.shade900,
      ),
      GetStartedPage(
        imagePath: 'images/graph.png',
        title: 'See Your Report',
        description: 'Analyze your mood trends with insightful reports.',
        backgroundColor: Colors.green.shade900,
      ),
    ];
  }
}
