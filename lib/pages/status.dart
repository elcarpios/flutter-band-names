import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';

class StatusPage extends StatefulWidget {
  StatusPage({Key key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Server Status ${socketService.serverStatus}')],
        )),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            socketService.emit('new-message',
                {'name': 'Victor', 'message': 'Hello from Flutter'});
          }),
    );
  }
}
