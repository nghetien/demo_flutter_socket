import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'model.dart';
import 'wifi_setup.dart';

class Server {
  final Unit8ListCallback onData;
  final DynamicCallback onError;

  Server({
    required this.onData,
    required this.onError,
  });

  ServerSocket? serverSocket;
  List<Socket> sockets = [];
  bool isRunning = false;

  Future start() async {
    runZoned(
      () async {
        serverSocket = await ServerSocket.bind(WifiSetup.$ip, WifiSetup.$port);
        isRunning = true;
        serverSocket!.listen(onRequest);
        final message = 'Server started on ${serverSocket!.address.address}:${serverSocket!.port}';
        onData(Uint8List.fromList(message.codeUnits));
      },
      onError: onError,
    );
  }

  void onRequest(Socket socket) {
    int index = -1;
    for (int i = 0; i < sockets.length; i++) {
      if (sockets[i].remoteAddress.address == socket.remoteAddress.address) {
        index = i;
        break;
      }
    }
    if (index != -1 && sockets.isNotEmpty) {
      sockets.removeAt(index);
    }
    sockets.add(socket);
    socket.listen((event) {
      final mess =
          'From ${socket.remoteAddress.address}:${socket.remotePort} ${String.fromCharCodes(event)}';
      onData(Uint8List.fromList(mess.codeUnits));
    });
  }

  Future close() async {
    await serverSocket!.close();
    serverSocket = null;
    for (final socket in sockets) {
      await socket.close();
    }
    isRunning = false;
  }

  void boardCast(String data) {
    for (final socket in sockets) {
      socket.write(data);
    }
  }
}
