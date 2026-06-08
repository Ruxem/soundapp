import 'package:flutter/material.dart';
import 'package:sound_app/providers/bluetooth_controller.dart';
import 'splash_screen.dart';


void main() {
  runApp(SoundApp());
}

class SoundApp extends StatelessWidget {
  final BluetoothController btController = BluetoothController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(btController: btController),
    );
  }
}
