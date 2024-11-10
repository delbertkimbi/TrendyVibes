import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:trendy_vibes/controllers/game_controllers.dart';
import '../core/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  final GameController controller = Get.find<GameController>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60 FPS
    )..addListener(() {
        controller.updateTiles(_animationController.value);
      });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/animations/background.riv',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildGameHeader(),
                Expanded(
                  child: _buildGameArea(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
            'Score: ${controller.score}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )).animate()
            .fadeIn(duration: 600.ms)
            .scale(delay: 300.ms),
          Row(
            children: List.generate(3, (index) => Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  Icons.favorite,
                  color: index < controller.lives.value 
                    ? Colors.red 
                    : Colors.grey,
                  size: 24,
                ).animate(
                  onPlay: (controller) => controller.repeat(),
                ).scale(
                  duration: 300.ms,
                  curve: Curves.easeInOut,
                ),
              );
            })),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    return Stack(
      children: [
        Row(
          children: List.generate(
            GameConfig.laneCount,
            (index) => _buildLane(index),
          ),
        ),
        Obx(() {
          return Stack(
            children: controller.tiles.map((tile) => _buildTile(tile)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildLane(int index) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: (index * 100).ms, duration: 600.ms)
      .slide(begin: const Offset(0, -0.2), curve: Curves.easeOutQuad);
  }

  Widget _buildTile(GameTile tile) {
    return Positioned(
      left: tile.lane * (Get.width / GameConfig.laneCount),
      top: tile.yPosition,
      child: GestureDetector(
        onTapDown: (_) => controller.handleTileTap(tile),
        child: Container(
          width: Get.width / GameConfig.laneCount,
          height: GameConfig.tileHeight,
          decoration: BoxDecoration(
            color: tile.hit ? Colors.transparent : AppColors.tileColor,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.tileColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: tile.perfectTiming && !tile.hit
            ? const Center(
                child: Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 24,
                ),
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).scale(
                duration: 300.ms,
                curve: Curves.easeInOut,
              )
            : null,
        ),
      ).animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutQuad),
    );
  }
}