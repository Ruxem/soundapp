import 'package:audioplayers/audioplayers.dart';
import 'package:sound_app/providers/bluetooth_controller.dart';
import 'package:sound_app/providers/command.dart';
import 'dart:typed_data';

class CommandViewModel {
  final BluetoothController btController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  CommandViewModel({required this.btController});

  Future<void> execute(Command command) async {
    try {
      await _audioPlayer.stop();
      await Future.delayed(const Duration(milliseconds: 50));

      if (command.isCustom) {
        if (command.bytes != null) {
          await _audioPlayer.play(BytesSource(Uint8List.fromList(command.bytes!)));
        } else if (command.soundFile.isNotEmpty) {
          await _audioPlayer.play(DeviceFileSource(command.soundFile));
        } else {
          print("No valid audio source found for custom command ${command.name}");
        }
      } else {
        if (command.soundFile.isNotEmpty) {
          await _audioPlayer.play(AssetSource(command.soundFile));
        } else {
          print("No valid asset found for command ${command.name}");
        }
      }

      if (btController.commandChar != null) {
        await btController.commandChar!.write(
          command.toByteList(),
          withoutResponse: true,
        );
      }
    } catch (e) {
      print("Audio error: $e");
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}