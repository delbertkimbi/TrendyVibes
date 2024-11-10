import 'dart:ui';

class GameConfig {
  static const double tileHeight = 180.0;
  static const double tileWidth = 90.0;
  static const int laneCount = 4;
  static const double initialSpeed = 300.0; // pixels per second
  static const double speedIncrease = 5.0; // speed increase per tile
  
  static const Map<String, int> difficultyMultipliers = {
    'Easy': 1,
    'Medium': 2,
    'Hard': 3,
  };
}

class AppColors {
  static const gradientStart = Color(0xFF2C1F63);
  static const gradientEnd = Color(0xFF1A1245);
  static const tileColor = Color(0xFF64B5F6);
  static const activeTileColor = Color(0xFF2196F3);
}

class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String starFilled = 'assets/images/star_filled.png';
  static const String starEmpty = 'assets/images/star_empty.png';
}