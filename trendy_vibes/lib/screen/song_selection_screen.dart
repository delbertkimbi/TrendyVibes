import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';

class SongSelectionScreen extends StatelessWidget {
  const SongSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildSongList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/coin.png', height: 24),
              const SizedBox(width: 8),
              Text(
                '550',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, curve: Curves.easeOutQuad),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Get.toNamed('/settings'),
          ).animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: 0.2, curve: Curves.easeOutQuad),
        ],
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sampleSongs.length,
      itemBuilder: (context, index) {
        final song = sampleSongs[index];
        return _buildSongCard(song, index);
      },
    );
  }

  Widget _buildSongCard(Song song, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: song.coverArt,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          song.title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          song.artist,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () => Get.toNamed(
            '/game',
            arguments: song,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tileColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Play',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ).animate(
      delay: (index * 100).ms,
    ).fadeIn(
      duration: 600.ms,
    ).slideY(
      begin: 0.2,
      curve: Curves.easeOutQuad,
    );
  }
}

class Song {
  final String title;
  final String artist;
  final String coverArt;
  final String audioPath;
  final String difficulty;

  Song({
    required this.title,
    required this.artist,
    required this.coverArt,
    required this.audioPath,
    required this.difficulty,
  });
}

final sampleSongs = [
  Song(
    title: 'Coller la petite',
    artist: 'Franko',
    coverArt: 'https://example.com/covers/coller_la_petite.jpg',
    audioPath: 'assets/audio/coller_la_petite.mp3',
    difficulty: 'Medium',
  ),
  Song(
    title: 'Maleya',
    artist: 'X-Maleya',
    coverArt: 'https://example.com/covers/maleya.jpg',
    audioPath: 'assets/audio/maleya.mp3',
    difficulty: 'Hard',
  ),
  Song(
    title: 'Petit Pays',
    artist: 'Loketo',
    coverArt: 'https://example.com/covers/petit_pays.jpg',
    audioPath: 'assets/audio/petit_pays.mp3',
    difficulty: 'Easy',
  ),
  // Add more Cameroonian songs here
];