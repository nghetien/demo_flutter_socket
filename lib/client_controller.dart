import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

import 'client.dart';
import 'wifi_setup.dart';

class ClientController extends ChangeNotifier {
  ClientController();

  ClientModel? clientModel;
  List<String> clientLogs = [];
  late Stream<NetworkAddress?> stream;
  NetworkAddress? address;

  final TextEditingController textEditingController = TextEditingController();

  void getIpAddress() async {
    print('subnet ${WifiSetup.$subnet}');
    stream = NetworkAnalyzer.discover2(WifiSetup.$subnet, WifiSetup.$port);
    stream.listen((NetworkAddress? networkAddress) {
      if (networkAddress != null && networkAddress.exists) {
        address = networkAddress;
        clientModel = ClientModel(
          hostName: networkAddress.ip ?? 'none HostName',
          port: WifiSetup.$port,
          onData: onData,
          onError: onError,
        );
        notifyListeners();
      }
    });
  }

  void getIpAddress2(String ip) async {
    stream = NetworkAnalyzer.discover2(ip, WifiSetup.$port);
    stream.listen((NetworkAddress? networkAddress) {
      if (networkAddress != null && networkAddress.exists) {
        address = networkAddress;
        clientModel = ClientModel(
          hostName: networkAddress.ip ?? 'none HostName',
          port: WifiSetup.$port,
          onData: onData,
          onError: onError,
        );
        notifyListeners();
      }
    });
  }

  Future connect() async {
    if (clientModel != null) {
      await clientModel!.connect();
      notifyListeners();
    }
  }

  void onData(Uint8List data) {
    clientLogs.add('fromServer ${clientModel!.hostName}: ${String.fromCharCodes(data)}');
    notifyListeners();
  }

  void onError(dynamic error) {
    debugPrint("Error: $error");
  }

  void sendMessage(String data) {
    clientModel!.sendMessage(data);
    clientLogs.add(data);
    notifyListeners();
  }


}
