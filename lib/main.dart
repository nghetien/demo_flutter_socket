import 'package:demo_flutter_socket/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'client_controller.dart';
import 'wifi_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WifiSetup.setIp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ServerController(),
          ),
          ChangeNotifierProvider(
            create: (_) => ClientController(),
          ),
        ],
        builder: (context, child) {
          return const MyHomePage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ServerController serverController;
  late ClientController clientController;

  @override
  void initState() {
    super.initState();
  }

  Widget serverWidget(BuildContext context) {
    serverController = context.watch<ServerController>();
    final serverRunning =
        serverController.server != null ? serverController.server?.isRunning ?? false : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Server',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        Text(
          'Status Server: ${serverRunning ? 'Running' : 'Stopped'}',
          style: TextStyle(
            fontSize: 18,
            color: serverRunning ? Colors.green : Colors.red,
          ),
        ),
        const Text(
          'All Server Socket Logs',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
          child: ListView.builder(
            itemCount: serverRunning ? serverController.server!.sockets.length : 0,
            itemBuilder: (context, index) {
              return Text(
                  '${serverController.server!.sockets[index].remoteAddress.address}:${serverController.server!.sockets[index].remotePort}');
            },
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          'Server Logs',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: ListView.builder(
            itemCount: serverController.serverLogs.length,
            itemBuilder: (context, index) {
              return Text(serverController.serverLogs[index]);
            },
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                serverController.toggleServer();
              },
              child: const Text('ToggleServer'),
            ),
            const SizedBox(
              width: 25,
            ),
            OutlinedButton(
              onPressed: () {
                serverController.onInit();
              },
              child: const Text('Init Server'),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: serverController.textEditingController,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                serverController.handleMessage(serverController.textEditingController.text);
                serverController.textEditingController.clear();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget clientWidget(BuildContext context) {
    clientController = context.watch<ClientController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Client',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        Text(
          'Status Client Connected: ${clientController.clientModel?.isConnected ?? false ? 'Connected' : 'Disconnected'}',
          style: TextStyle(
            fontSize: 18,
            color: clientController.clientModel?.isConnected ?? false ? Colors.green : Colors.red,
          ),
        ),
        Text(
          'Curent ip: ${clientController.address?.ip ?? 'no Ip'}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Row(
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                clientController.getIpAddress();
              },
              child: const Text('Get IP'),
            ),
            OutlinedButton(
              onPressed: () {
                clientController.connect();
              },
              child: const Text('Connect'),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          'Client Logs',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(child: TextField(
              controller: clientController.textEditingController,
            ),),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                clientController.sendMessage(clientController.textEditingController.text);
                clientController.textEditingController.clear();
              },
            ),
          ],
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: ListView.builder(
            itemCount: clientController.clientLogs.length,
            itemBuilder: (context, index) {
              return Text(clientController.clientLogs[index]);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity example app'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            serverWidget(context),
            const SizedBox(
              height: 100,
            ),
            clientWidget(context),
          ],
        ),
      ),
    );
  }
}
