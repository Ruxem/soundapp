import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileHandler {
  static Future<PickedFile?> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: kIsWeb,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;

    if (kIsWeb) {
      return PickedFile(
        name: file.name,
        bytes: file.bytes,
      );
    } else {
      return PickedFile(
        name: file.name,
        path: file.path,
      );
    }
  }
}

class PickedFile {
  final String name;
  final String? path;
  final Uint8List? bytes;

  PickedFile({required this.name, this.path, this.bytes});
}