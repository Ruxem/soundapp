import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_app/providers/bluetooth_controller.dart';

class DeviceListPage extends StatefulWidget {
  final BluetoothController btController;

  const DeviceListPage({super.key, required this.btController});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  List<ScanResult> devices = [];
  bool isScanning = false;

  StreamSubscription? scanSub;

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  Future<void> startScan() async {
    await requestPermissions();

    setState(() {
      devices.clear();
      isScanning = true;
    });

    scanSub = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devices = results;
      });
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
    );

    await stopScan();
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await scanSub?.cancel();

    setState(() {
      isScanning = false;
    });
  }

  Future<void> connect(ScanResult r) async {
    await stopScan();

    await widget.btController.connectToDevice(r.device);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Connected to ${r.device.platformName.isEmpty ? r.device.remoteId : r.device.platformName}",
        ),
      ),
    );
  }

  @override
  void dispose() {
    scanSub?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Devices"),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.search),
            onPressed: isScanning ? stopScan : startScan,
          )
        ],
      ),

      body: Column(
        children: [
          if (isScanning)
            const LinearProgressIndicator(),

          Expanded(
            child: devices.isEmpty
                ? const Center(child: Text("No devices found"))
                : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final r = devices[index];

                final name = r.device.platformName.isNotEmpty
                    ? r.device.platformName
                    : "Unknown Device";

                return ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(name),
                  subtitle: Text(r.device.remoteId.toString()),
                  trailing: ElevatedButton(
                    onPressed: () => connect(r),
                    child: const Text("Connect"),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? stopScan : startScan,
        child: Icon(isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}