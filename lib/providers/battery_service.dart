import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

import 'package:sound_app/providers/vibration_service.dart';

class BatteryService {
  final Battery _battery = Battery();
  final VibrationService _vibrationService = VibrationService();

  BluetoothDevice? device;

  Stream<int> get phoneBatteryStream =>
      _battery.onBatteryStateChanged.asyncMap(
            (_) => _battery.batteryLevel,
      );

  Future<int> get currentPhoneBattery => _battery.batteryLevel;

  Future<int?> getEsp32Battery() async {
    if (device == null) return null;

    final services = await device!.discoverServices();

    for (final s in services) {
      if (s.uuid.toString() == "0000180f-0000-1000-8000-00805f9b34fb") {
        for (final c in s.characteristics) {
          if (c.uuid.toString() ==
              "00002a19-0000-1000-8000-00805f9b34fb") {
            final value = await c.read();
            return value.first;
          }
        }
      }
    }

    return null;
  }

  Stream<int> esp32BatteryStream(Duration interval) async* {
    while (true) {
      final level = await getEsp32Battery();
      if (level != null) yield level;
      await Future.delayed(interval);
    }
  }
  void checkBatteryLevel(int level, Function(int, int) onThresholdReached) {
    _vibrationService.checkBatteryLevel(level, onThresholdReached);
  }
}