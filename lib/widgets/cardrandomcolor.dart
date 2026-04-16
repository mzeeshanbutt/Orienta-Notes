import 'package:flutter/material.dart';

class ColorHelper {
  // A professional "Pastel" palette. Easy on the eyes.
  static final List<Color> noteColors = [
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.teal.shade200,
    Colors.pink.shade200,
    Colors.black,
    //  Colors.red.shade200,
    // Colors.green.shade200,
    // Colors.blue.shade200,
    // Colors.orange.shade200,
    // Colors.purple.shade200,
    // Colors.teal.shade200,
    // Colors.pink.shade200,
    // Colors.black,
    // Adding a dark color to test your white text logic
  ];

  // 1. Get color based on index (Stable: won't change on scroll)
  static Color getNoteColor(int index) {
    // The modulus operator (%) loops through the list repeatedly
    return noteColors[index % noteColors.length];
  }

  // 2. The Professional Contrast Check
  static Color getTextColorForBackground(Color backgroundColor) {
    // computeLuminance returns 0.0 (dark) to 1.0 (light)
    // If luminance > 0.5, the background is light, so use BLACK text.
    // Otherwise, use WHITE text.
    return backgroundColor.computeLuminance() > 0.3 ? Colors.black : Colors.white;
  }
}
