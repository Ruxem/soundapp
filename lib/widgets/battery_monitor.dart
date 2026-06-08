import 'package:flutter/material.dart';
import '../providers/battery_service.dart';

class BatteryMonitor extends StatefulWidget {
  final Widget child;
  final Function(int, int)? onBatteryThreshold;

  const BatteryMonitor({
    super.key,
    required this.child,
    this.onBatteryThreshold,
  });

  @override
  State<BatteryMonitor> createState() => _BatteryMonitorState();
}

class _BatteryMonitorState extends State<BatteryMonitor> {
  final BatteryService _batteryService = BatteryService();

  int? _phoneBattery;
  int? _espBattery;

  @override
  void initState() {
    super.initState();
    _initBatteryMonitoring();
  }

  void _initBatteryMonitoring() async {
    _phoneBattery = await _batteryService.currentPhoneBattery;

    _batteryService.phoneBatteryStream.listen((level) {
      setState(() {
        _phoneBattery = level;
      });

      _checkBattery(level, isPhone: true);
    });
    _startEsp32BatteryLoop();
  }

  void _startEsp32BatteryLoop() {
    _batteryService
        .esp32BatteryStream(const Duration(seconds: 60))
        .listen((level) {
      setState(() {
        _espBattery = level;
      });

      _checkBattery(level, isPhone: false);
    });
  }

  void _checkBattery(int level, {required bool isPhone}) {
    _batteryService.checkBatteryLevel(level, (threshold, currentLevel) {
      _showBatteryNotification(
        threshold,
        currentLevel,
        isPhone: isPhone,
      );

      widget.onBatteryThreshold?.call(threshold, currentLevel);
    });
  }

  void _showBatteryNotification(
      int threshold,
      int currentLevel, {
        required bool isPhone,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${isPhone ? "Phone" : "ESP32"} battery: '
              '$currentLevel% - $threshold% threshold reached!',
        ),
        backgroundColor: _getNotificationColor(threshold),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getNotificationColor(int threshold) {
    switch (threshold) {
      case 50:
        return Colors.orange;
      case 30:
        return Colors.deepOrange;
      case 15:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}