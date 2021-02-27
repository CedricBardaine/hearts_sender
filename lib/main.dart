import 'package:flutter/material.dart';
import 'package:hearts_sender/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hearts Sender',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        // 0xFF669C5E
        primarySwatch: const MaterialColor(0xFF669C5E, const <int, Color>{
          50: const Color(0xFF669C5E),
          100: const Color(0xFF669C5E),
          200: const Color(0xFF669C5E),
          300: const Color(0xFF669C5E),
          400: const Color(0xFF669C5E),
          500: const Color(0xFF669C5E),
          600: const Color(0xFF669C5E),
          700: const Color(0xFF669C5E),
          800: const Color(0xFF669C5E),
          900: const Color(0xFF669C5E),
        }),
        primaryColor: Color(0xFF669C5E),
        accentColor: Color(0xFFE8A90C),

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
