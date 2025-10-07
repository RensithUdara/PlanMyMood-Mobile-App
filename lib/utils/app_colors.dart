import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFF5A962);
  static const Color pressedOrange = Color(0xFFE89850);
  static const Color darkCharcoal = Color(0xFF2C2C2C);

  // Background Colors
  static const Color creamBeige = Color(0xFFF5F1E8);
  static const Color lightCream = Color(0xFFFAF8F3);
  static const Color mediumBeige = Color(0xFFE8E3D8);
  static const Color white = Color(0xFFFFFFFF);

  // Mood Colors
  static const Color joyful = Color(0xFFFFE066);
  static const Color energy = Color(0xFFFF9C5C);
  static const Color inspired = Color(0xFF9B8CE8);
  static const Color sad = Color(0xFF6BB6E8);
  static const Color angry = Color(0xFFE86B6B);
  static const Color apathetic = Color(0xFFA67C52);
  static const Color tired = Color(0xFF9E9E9E);
  static const Color notSure = Color(0xFFF5D76E);

  // Task Colors
  static const Color purpleTask = Color(0xFF9B8CE8);
  static const Color yellowTask = Color(0xFFF5D76E);
  static const Color cyanTask = Color(0xFF6BB6E8);
  static const Color greenTask = Color(0xFF7BC47B);
  static const Color grayDisabled = Color(0xFFCCCCCC);

  // Text Colors
  static const Color primaryText = Color(0xFF2C2C2C);
  static const Color secondaryText = Color(0xFF6B6B6B);
  static const Color lightText = Color(0xFFFFFFFF);

  // Shadow Color
  static const Color shadow = Color(0x1A000000);

  // Helper method to get mood color by name
  static Color getMoodColor(String moodName) {
    switch (moodName.toLowerCase()) {
      case 'joyful':
        return joyful;
      case 'energy':
        return energy;
      case 'inspired':
        return inspired;
      case 'sad':
        return sad;
      case 'angry':
        return angry;
      case 'apathetic':
        return apathetic;
      case 'tired':
        return tired;
      case 'not sure':
        return notSure;
      default:
        return primaryOrange;
    }
  }

  // Helper method to get task icon color by type
  static Color getTaskIconColor(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'purple':
        return purpleTask;
      case 'yellow':
        return yellowTask;
      case 'cyan':
        return cyanTask;
      case 'green':
        return greenTask;
      default:
        return primaryOrange;
    }
  }
}
