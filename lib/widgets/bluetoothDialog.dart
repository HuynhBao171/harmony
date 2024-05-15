import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:harmony/main.dart';

class BleScanner extends StatefulWidget {
  final BluetoothDevice? connectedDevice;

  const BleScanner({super.key, this.connectedDevice});

  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  List<DeviceWithState> devices = [];
  bool isScanning = false;
  StreamSubscription? _scanSubscription;
  DeviceWithState? connectedDevice;

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() async {
    setState(() {
      isScanning = true;
      devices.clear();
      connectedDevice = null;
    });
    devices.clear();

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.any((device) => device.device == result.device)) {
          DeviceWithState newDevice = DeviceWithState(
              result.device, DeviceConnectionState.disconnected);
          if ((newDevice.device.platformName.isNotEmpty)) {
            setState(() {
              devices.add(newDevice);
            });
          }
        }
      }
    });

    await Future.delayed(const Duration(seconds: 5));

    FlutterBluePlus.stopScan();

    setState(() {
      isScanning = false;
    });
  }

  Future<void> readData(BluetoothCharacteristic characteristic) async {
    List<int> value = await characteristic.read();
    String data = utf8.decode(value);
    logger.i('Data received: $data');
  }

  Future<void> writeData(
      BluetoothCharacteristic characteristic, String data) async {
    List<int> value = utf8.encode(data);
    await characteristic.write(value);
    logger.i('Data written: $data');
  }

  void connectToDevice(DeviceWithState deviceWithState) async {
    setState(() {
      deviceWithState.connectionState = DeviceConnectionState.connecting;
    });

    try {
      await deviceWithState.device.connect();
      setState(() {
        deviceWithState.connectionState = DeviceConnectionState.connected;
        connectedDevice = deviceWithState;
      });

      // Demo read and write data
      List<BluetoothService> services =
          await deviceWithState.device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          await readData(characteristic);
          await writeData(characteristic, "Hello from Flutter!");
        }
      }

      Navigator.pop(context, deviceWithState.device);
    } catch (e) {
      setState(() {
        deviceWithState.connectionState = DeviceConnectionState.failed;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ContentBox(
        isScanning: isScanning,
        devices: devices,
        connectedDevice: connectedDevice,
        connectToDevice: connectToDevice,
      ),
    );
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}

class ContentBox extends StatelessWidget {
  final bool isScanning;
  final List<DeviceWithState> devices;
  final DeviceWithState? connectedDevice;
  final Function(DeviceWithState) connectToDevice;

  const ContentBox({
    super.key,
    required this.isScanning,
    required this.devices,
    required this.connectedDevice,
    required this.connectToDevice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isScanning
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )
              : devices.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No devices found'),
                    )
                  : Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          final deviceWithState = devices[index];
                          return ListTile(
                            leading: const Icon(Icons.bluetooth),
                            title: Text(
                              deviceWithState.device.platformName,
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              deviceWithState.device.remoteId.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: deviceWithState.connectionState ==
                                    DeviceConnectionState.connected
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : deviceWithState.connectionState ==
                                        DeviceConnectionState.connecting
                                    ? const CircularProgressIndicator()
                                    : deviceWithState.connectionState ==
                                            DeviceConnectionState.failed
                                        ? const Icon(Icons.cancel,
                                            color: Colors.red)
                                        : null,
                            onTap: () {
                              connectToDevice(deviceWithState);
                            },
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

enum DeviceConnectionState {
  disconnected,
  connecting,
  connected,
  failed,
}

class DeviceWithState {
  final BluetoothDevice device;
  DeviceConnectionState connectionState;

  DeviceWithState(this.device, this.connectionState);
}
