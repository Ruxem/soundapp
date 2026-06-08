import 'package:vibration/vibration.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  bool _fiftyNotified = false;
  bool _thirtyNotified = false;
  bool _fifteenNotified = false;

  Future<void> vibrate(int count, {int duration = 500}) async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;

    if (!hasVibrator) return;

    for (int i = 0; i < count; i++) {
      Vibration.vibrate(duration: duration);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  void checkBatteryLevel(
      int level,
      Function(int threshold, int currentLevel) onThresholdReached,
      ) {
    if (level <= 15 && !_fifteenNotified) {
      _trigger(15, level, 3, onThresholdReached);
      _fifteenNotified = true;
    }
    else if (level <= 30 && !_thirtyNotified) {
      _trigger(30, level, 2, onThresholdReached);
      _thirtyNotified = true;
    }
    else if (level <= 50 && !_fiftyNotified) {
      _trigger(50, level, 1, onThresholdReached);
      _fiftyNotified = true;
    }

    _resetIfRecovered(level);
  }

  void _trigger(
      int threshold,
      int level,
      int vibrationCount,
      Function(int, int) callback,
      ) {
    callback(threshold, level);
    vibrate(vibrationCount);
  }

  void _resetIfRecovered(int level) {
    if (level > 50) _fiftyNotified = false;
    if (level > 30) _thirtyNotified = false;
    if (level > 15) _fifteenNotified = false;
  }

  void resetNotifications() {
    _fiftyNotified = false;
    _thirtyNotified = false;
    _fifteenNotified = false;
  }
}