import 'package:flutter/material.dart';
import 'package:simple_note_app/Screens/writeNotes.dart';

import 'Screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note App",
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        "writeNotes": (context) => const WriteNotesScreen(),
      },
    );
  }
}
