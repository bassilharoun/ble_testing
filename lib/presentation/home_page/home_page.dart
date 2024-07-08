import 'dart:async';
import 'dart:io' show Platform;

import 'package:ble_test/data/models/position_response.dart';
import 'package:ble_test/data/services/api_service.dart';
import 'package:ble_test/presentation/home_page/widgets/map_position.dart';
import 'package:ble_test/presentation/result_screen/result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _scanStarted = false;
  bool startInfiniteScan = false;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  List<DiscoveredDevice> _devices = [];
  List<Map<String, dynamic>> beaconData = [
    // {"UUID": "10000000E561EC711ED2000000000002", "RSSI": -65},
    // {"UUID": "10000000E186DA95632F000000000003", "RSSI": -67},
    // {"UUID": "10000000EEDC5FE7AD8F000000000008", "RSSI": -72},
    // {"UUID": "10000000E504E28EF235000000000004", "RSSI": -75}
  ];
  List<String> nearby3BeaconsStrings = [];

  Timer? _scanTimeoutTimer;
  int _lastDeviceCount = 0;

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();
    }
  }

  Future<void> _startScan() async {
    await _requestPermissions();

    if (await Permission.location.isGranted) {
      setState(() {
        _scanStarted = true;
        _devices.clear();
      });

      _lastDeviceCount = 0;
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        setState(() {
          if (!_devices.any((d) => d.id == device.id)) {
            if (device.name.toLowerCase().contains("beacon")) {
              _devices.add(device);
            }
          }
        });
      });

      _startScanTimeout();
    } else {
      print("Location permission not granted");
    }
  }

  Future<void> _startInfiniteScan() async {
    await _requestPermissions();

    if (await Permission.location.isGranted) {
      setState(() {
        startInfiniteScan = true;
        _devices.clear();
      });

      _lastDeviceCount = 0;
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        setState(() {
          // if (!_devices.any((d) => d.id == device.id)) {
          if (device.name.toLowerCase().contains("beacon")) {
            _devices.add(device);
          }
          // }
        });
      });

      // _startScanTimeout();
    } else {
      print("Location permission not granted");
    }
  }

  void _startScanTimeout() {
    _scanTimeoutTimer?.cancel();
    _scanTimeoutTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_devices.length == _lastDeviceCount) {
        _stopScan();
      } else {
        _lastDeviceCount = _devices.length;
      }
    });
  }

  void _stopScan() {
    _scanStream.cancel();
    _scanTimeoutTimer?.cancel();
    setState(() {
      _scanStarted = false;
      startInfiniteScan = false;
    });
  }

  @override
  void dispose() {
    _scanStream.cancel();
    _scanTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${_devices.length} beacon in the queue"),
      ),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return ListTile(
            title: Text("name : ${device.name} \n id: ${device.id}"),
            subtitle: Text(
                "${"uuid: ${device.serviceUuids} \n manufacturerData: ${device.manufacturerData}"} \n serviceData: ${device.serviceData}"),
            trailing: Text("${device.rssi} dBm"),
          );
        },
      ),
      persistentFooterButtons: [
        _scanStarted
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: _stopScan,
                child: const Icon(Icons.stop),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _startScan,
                child: const Icon(Icons.search),
              ),
        startInfiniteScan
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: _stopScan,
                child: const Icon(Icons.stop),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _startInfiniteScan
                //  () async {
                //   beaconData = [];

                //   for (int i = 0; i < 25; i++) {
                //     for (int j = 0; j < 5; j++) {
                //       try {
                //         await _startInfiniteScan();
                //         await Future.delayed(Duration(seconds: 2));

                //         beaconData.addAll(_devices.map((beacon) {
                //           return {
                //             "UUID": beacon.id.toString(),
                //             "RSSI": beacon.rssi,
                //           };
                //         }).toList());
                //         print("$beaconData");
                //         print(beaconData.length);

                //         // _stopScan();
                //         await Future.delayed(
                //             Duration(seconds: 3)); // Short delay between scans
                //       } catch (e) {
                //         if (e.toString().contains("ScanFailure.unknown")) {
                //           await _handleThrottleError(e.toString());
                //           j--; // Retry the current iteration of the inner loop
                //         } else {
                //           throw e;
                //         }
                //       }
                //       if (startInfiniteScan == false) {
                //         _stopScan();
                //         break;
                //       }
                //     }
                //     if (startInfiniteScan == false) {
                //       _stopScan();
                //       break;
                //     }
                //     // Wait for the remainder of the 30-second period
                //     await Future.delayed(Duration(seconds: 20));
                //   }
                //   _stopScan();
                // }
                ,
                child: const Icon(CupertinoIcons.infinite),
              ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            beaconData = [];

            beaconData = _devices.map((beacon) {
              return {
                "UUID": beacon.id.toString(),
                "RSSI": beacon.rssi,
              };
            }).toList();

            // for (int i = 0; i < _devices.length; i++) {
            //   beaconData.add({
            //     "UUID": "${_devices[i].serviceUuids.first}",
            //     "RSSI": _devices[i].rssi.toInt()
            //     // "UUID": beaconData[i]["UUID"],
            //     // "RSSI": beaconData[i]["RSSI"]
            //   });
            // }

            if (_devices.isNotEmpty) {
              List<DiscoveredDevice> nearby3Beacons = [];

              _devices.sort((a, b) =>
                  b.rssi.compareTo(a.rssi)); // Sort by RSSI, descending
              nearby3Beacons =
                  _devices.take(3).toList(); // Take the top 3 devices
              for (int i = 0; i < nearby3Beacons.length; i++) {
                nearby3BeaconsStrings = nearby3Beacons.map((beacon) {
                  return "\n${beacon.name} , ${beacon.rssi}\n";
                }).toList();
              }

              PositionResponse? myTmPosition = await ApiService()
                  .sendBeaconData(beaconData, "UnknownListByMac");

              PositionResponse? myLs5Position = await ApiService()
                  .sendBeaconData(beaconData, "ListOfBeacons5");

              PositionResponse? myLsAllPosition = await ApiService()
                  .sendBeaconData(beaconData, "ListOfBeaconsAll");

              if (myTmPosition != null &&
                  myLs5Position != null &&
                  myLsAllPosition != null) {
                // showResponseDialog(context, myPosition);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ResultScreen(myTmPosition, myLs5Position,
                      myLsAllPosition, nearby3BeaconsStrings);
                }));
              } else if (_devices.length < 3) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          'Not enough beacons detected. Please try again.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text(
                          'Because of an Internal Server error, we could not determine your position. Please try again. \n your data sent : \n $beaconData'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                        'Not enough beacons detected. Please try again.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text("Where am I?"),
        ),
      ],
    );
  }

  Future<void> _handleThrottleError(String message) async {
    final pattern = RegExp(r'suggested retry date is (.+) GMT\+03:00');
    final match = pattern.firstMatch(message);
    if (match != null) {
      final retryDateString = match.group(1)!;
      final retryDate =
          DateFormat("EEE MMM dd HH:mm:ss").parse(retryDateString, true);
      final now = DateTime.now();
      final delay = retryDate.difference(now).inMilliseconds;
      if (delay > 0) {
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }
}
