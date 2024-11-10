import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendy_vibes/controllers/game_controllers.dart';
import 'package:trendy_vibes/screen/game_screen.dart';
import 'package:trendy_vibes/screen/song_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TrendyVibes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SongSelectionScreen()),
        GetPage(
          name: '/game',
          page: () => const GameScreen(),
          binding: BindingsBuilder(() {
            Get.put(GameController());
          }),
        ),
      ],
    );
  }
}
