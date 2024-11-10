import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';

class GameController extends GetxController {
  final player = AudioPlayer();
  final RxInt score = 0.obs;
  final RxInt lives = 3.obs;
  final RxDouble currentSpeed = GameConfig.initialSpeed.obs;
  final RxBool isPlaying = false.obs;
  final RxList<GameTile> tiles = <GameTile>[].obs;
  final RxInt stars = 0.obs;
  
  late String currentSong;
  late String currentArtist;
  late String difficulty;
  
  @override
  void onInit() {
    super.onInit();
    player.onPlayerComplete.listen((_) {
      endGame();
    });
  }

  Future<void> startGame(String songPath, String songName, String artist, String diff) async {
    score.value = 0;
    lives.value = 3;
    currentSpeed.value = GameConfig.initialSpeed;
    isPlaying.value = true;
    currentSong = songName;
    currentArtist = artist;
    difficulty = diff;
    tiles.clear();
    
    try {
      await player.play(AssetSource(songPath));
      _startTileGeneration();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      Get.snackbar(
        'Error',
        'Failed to start the game. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void _startTileGeneration() {
    Future.doWhile(() async {
      if (!isPlaying.value) return false;
      
      tiles.add(GameTile(
        lane: (tiles.length % GameConfig.laneCount),
        yPosition: 0,
      ));
      
      await Future.delayed(Duration(milliseconds: (1000 / currentSpeed.value).round()));
      return isPlaying.value;
    });
  }
  
  void handleTileTap(GameTile tile) {
    if (!tile.isActive || tile.hit) return;
    
    final multiplier = GameConfig.difficultyMultipliers[difficulty] ?? 1;
    
    if (tile.perfectTiming) {
      score.value += 2 * multiplier;
      currentSpeed.value += GameConfig.speedIncrease;
    } else {
      score.value += multiplier;
    }
    
    tile.hit = true;
    tiles.remove(tile);
    update();
  }
  
  void updateTiles(double dt) {
    final screenHeight = Get.height;
    tiles.removeWhere((tile) {
      tile.yPosition += currentSpeed.value * dt;
      if (tile.yPosition > screenHeight) {
        missedTile();
        return true;
      }
      return false;
    });
    update();
  }
  
  void missedTile() {
    lives.value--;
    if (lives.value <= 0) {
      endGame();
    }
  }
  
  void endGame() {
    isPlaying.value = false;
    player.stop();
    stars.value = (score.value / 100).clamp(0, 3).floor();
    _saveHighScore();
  }
  
  void _saveHighScore() {
    // TODO: Implement high score saving logic
  }
  
  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}

class GameTile {
  final int lane;
  double yPosition;
  bool isActive;
  bool hit;
  bool perfectTiming;
  
  GameTile({
    required this.lane,
    required this.yPosition,
    this.isActive = true,
    this.hit = false,
    this.perfectTiming = false,
  });
}
