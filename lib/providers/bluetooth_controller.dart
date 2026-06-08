import 'dart:io';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController {
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? commandChar;

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      connectedDevice = device;

      print("Connecting to: ${device.platformName}");

      await device.connect(
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );

      print("Connected to: ${device.platformName}");

      await _findCharacteristic();
    } catch (e) {
      print("Connection error: $e");
    }
  }

  Future<void> _findCharacteristic() async {
    if (connectedDevice == null) return;

    final services = await connectedDevice!.discoverServices();

    BluetoothCharacteristic? fallback;

    for (var service in services) {
      print("SERVICE: ${service.uuid}");

      for (var c in service.characteristics) {
        print("CHAR: ${c.uuid}");
        print("PROPS: ${c.properties}");

        if ((c.properties.write || c.properties.writeWithoutResponse) &&
            commandChar == null) {
          fallback = c;
        }

        if (c.uuid.toString() ==
            "00000000-0000-0000-0000-000000000002") {
          commandChar = c;
          print("Preferred characteristic selected: ${c.uuid}");
          return;
        }
      }
    }

    if (commandChar == null && fallback != null) {
      commandChar = fallback;
      print("Using fallback writable characteristic: ${fallback.uuid}");
    }

    if (commandChar == null) {
      print("No writable characteristic found!");
    }
  }

  Future<void> sendCommand(String command) async {
    if (commandChar == null) {
      print("Cannot send: No characteristic");
      return;
    }

    try {
      print("Sending: $command");

      await commandChar!.write(
        utf8.encode(command),
        withoutResponse: true,
      );

      print("Command sent");
    } catch (e) {
      print("Send error: $e");
    }
  }

  Future<void> sendAudioFile(File file) async {
    if (commandChar == null) {
      print("Cannot send audio: No characteristic");
      return;
    }

    final bytes = await file.readAsBytes();
    const int chunkSize = 20;

    print("Sending audio... (${bytes.length} bytes)");

    for (int i = 0; i < bytes.length; i += chunkSize) {
      final chunk = bytes.sublist(
        i,
        (i + chunkSize > bytes.length) ? bytes.length : i + chunkSize,
      );

      await commandChar!.write(
        chunk,
        withoutResponse: true,
      );

      await Future.delayed(const Duration(milliseconds: 20));
    }

    print("Audio sent successfully");
  }

  Future<void> disconnect() async {
    try {
      await connectedDevice?.disconnect();
      print("Disconnected");
    } catch (e) {
      print("Disconnect error: $e");
    }

    connectedDevice = null;
    commandChar = null;
  }
}