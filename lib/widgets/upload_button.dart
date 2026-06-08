import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sound_app/providers/bluetooth_controller.dart';
import 'package:sound_app/providers/file_handler.dart';
import 'dart:io';

class UploadButton extends StatelessWidget {
  final BluetoothController btController;

  const UploadButton({super.key, required this.btController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final pickedFile = await FileHandler.pickAudioFile();

        if (pickedFile == null) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Kiválasztott fájl: ${kIsWeb ? pickedFile.name : pickedFile.path!.split('/').last}",
            ),
          ),
        );

        if (!kIsWeb && pickedFile.path != null) {
          final file = File(pickedFile.path!);
          await btController.sendAudioFile(file);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Weben a fájl küldés még nem támogatott")),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
      icon: const Icon(Icons.upload_file, color: Colors.black),
      label: const Text(
        "Hangfájl feltöltése",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}