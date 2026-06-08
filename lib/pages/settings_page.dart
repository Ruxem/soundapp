import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_app/providers/bluetooth_controller.dart';

Future<void> requestPermissions() async {
  final status = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.location,
  ].request();

  if (status[Permission.bluetoothScan]?.isGranted != true ||
      status[Permission.bluetoothConnect]?.isGranted != true ||
      status[Permission.location]?.isGranted != true) {
    debugPrint("Some permissions were not granted");
    return;
  }

  debugPrint("All permissions granted!");
}

class SettingsPage extends StatefulWidget {
  final BluetoothController btController;

  const SettingsPage({super.key, required this.btController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _loading = false;
  bool _scanning = false;

  List<ScanResult> devices = [];
  StreamSubscription? scanSub;

  Future<void> startScan() async {
    await requestPermissions();

    setState(() {
      _scanning = true;
      devices.clear();
    });

    scanSub = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devices = results;
      });
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
    );

    await Future.delayed(const Duration(seconds: 11));
    await stopScan();
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await scanSub?.cancel();

    setState(() {
      _scanning = false;
    });
  }

  Future<void> connect(ScanResult r) async {
    setState(() => _loading = true);

    try {
      await stopScan();

      await widget.btController.connectToDevice(r.device);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Connected to ${r.device.platformName.isEmpty
                ? r.device.remoteId
                : r.device.platformName}",
          ),
        ),
      );
    } catch (e) {
      debugPrint("Connect error: $e");
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    scanSub?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text("Bluetooth Devices"),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          SizedBox(
            width: 250,
            height: 60,
            child: ElevatedButton(
              onPressed: _scanning ? stopScan : startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _scanning ? "Stop Scanning" : "Scan Devices",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: 250,
            height: 60,
            child: ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                await widget.btController.sendCommand("HELLO");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Send Test (HELLO)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          if (_scanning)
            const LinearProgressIndicator(),

          const SizedBox(height: 10),

          Expanded(
            child: devices.isEmpty
                ? const Center(
              child: Text("No devices found"),
            )
                : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final r = devices[index];

                final name = r.device.platformName.isNotEmpty
                    ? r.device.platformName
                    : "Unknown Device";

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.bluetooth),
                    title: Text(name),
                    subtitle: Text(r.device.remoteId.toString()),
                    trailing: ElevatedButton(
                      onPressed: _loading ? null : () => connect(r),
                      child: const Text("Connect"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}