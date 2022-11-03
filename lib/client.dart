import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class ClientModel {
  String hostName;
  int port;
  Unit8ListCallback onData;
  DynamicCallback onError;

  ClientModel({
    required this.hostName,
    required this.port,
    required this.onData,
    required this.onError,
  });

  bool isConnected = false;
  Socket? socket;
  final deviceInfo = DeviceInfoPlugin();

  Future connect() async {
    try {
      socket = await Socket.connect(hostName, port);
      final info = await deviceInfo.androidInfo;
      socket!.listen(
        onData,
        onError: onError,
        onDone: () async {
          disconnect(info);
        },
      );
      socket!.write('Hello from ${info.brand} ${info.device} ${info.model} ${info.id} with IP connecting to $hostName:$port');
      isConnected = true;
    } catch (e) {
      debugPrint('connect error: $e');
    }
  }

  Future disconnect(AndroidDeviceInfo androidDeviceInfo) async {
    final message = "${androidDeviceInfo.brand} ${androidDeviceInfo.device} disconnected";
    sendMessage(message);
    isConnected = false;
    if (socket != null) {
      socket!.destroy();
    }
  }

  void sendMessage(String data) {
    socket!.write(data);
  }
}
