import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'server.dart';

class ServerController extends ChangeNotifier {
  ServerController();

  Server? server;
  final List<String> serverLogs = [];
  final TextEditingController textEditingController = TextEditingController();

  void onData(Uint8List data) {
    serverLogs.add(String.fromCharCodes(data));
    notifyListeners();
  }

  void onError(dynamic error) {
    debugPrint("Error: $error");
  }

  Future toggleServer() async {
    if (!server!.isRunning) {
      await server!.start();
    } else {
      await server!.close();
      serverLogs.clear();
    }
    notifyListeners();
  }

  void onInit() {
    server = Server(
      onData: onData,
      onError: onError,
    );
    toggleServer();
  }

  void handleMessage(String data) {
    server!.boardCast(data);
    serverLogs.add(data);
    notifyListeners();
  }
}
