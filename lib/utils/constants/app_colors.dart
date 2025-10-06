import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF667eea);
  static const Color primaryDark = Color(0xFF764ba2);
  static const Color primaryLight = Color(0xFF6B73FF);

  // Secondary Colors
  static const Color secondary = Color(0xFF764ba2);
  static const Color secondaryLight = Color(0xFF9B59B6);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF2D2D2D);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Colors.white;
  static const Color textDark = Color(0xFF2C3E50);

  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Todo Status Colors
  static const Color todoPending = Color(0xFFFF9800);
  static const Color todoInProgress = Color(0xFF9C27B0);
  static const Color todoCompleted = Color(0xFF4CAF50);
  static const Color todoOverdue = Color(0xFFF44336);

  // Priority Colors
  static const Color priorityLow = Color(0xFF4CAF50);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityHigh = Color(0xFFF44336);

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Splash Screen Colors
  static const Color splashGradientStart = Color(0xFF667eea);
  static const Color splashGradientMiddle = Color(0xFF764ba2);
  static const Color splashGradientEnd = Color(0xFF6B73FF);

  // Card Colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color cardShadow = Color(0x1A000000);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF667eea);
  static const Color buttonSecondary = Color(0xFF764ba2);
  static const Color buttonSuccess = Color(0xFF27AE60);
  static const Color buttonWarning = Color(0xFFF39C12);
  static const Color buttonError = Color(0xFFE74C3C);

  // Input Field Colors
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocused = Color(0xFF667eea);

  // Divider Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF6B73FF),
  ];

  static const List<Color> splashGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF6B73FF),
  ];

  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return todoPending;
      case 'in_progress':
        return todoInProgress;
      case 'completed':
        return todoCompleted;
      case 'overdue':
        return todoOverdue;
      default:
        return textSecondary;
    }
  }

  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      default:
        return textSecondary;
    }
  }
}
