import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  Color primaryColor = Colors.red[600];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    bool isConected = socketService.serverStatus == ServerStatus.Online;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: isConected
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: primaryColor),
          )
        ],
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildBandTile(bands[index]))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
        elevation: 5,
      ),
    );
  }

  Dismissible _buildBandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 10),
        color: primaryColor,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Remove',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            band.name.substring(0, 2),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 16),
        ),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  void _addNewBand() {
    print('Adding new band');

    final TextEditingController textController = new TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Add new band name:'),
                content: TextField(
                  controller: textController,
                ),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () => _addBandToList(textController.text),
                    child: Text('Add'),
                    color: primaryColor,
                  )
                ],
              ));
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext contnext) => CupertinoAlertDialog(
                title: Text('New band name:'),
                content: CupertinoTextField(
                  controller: textController,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('Add'),
                      isDefaultAction: true,
                      onPressed: () => _addBandToList(textController.text)),
                  CupertinoDialogAction(
                      child: Text('Dismiss'),
                      isDestructiveAction: true,
                      onPressed: () => Navigator.pop(context))
                ],
              ));
    }
  }

  void _addBandToList(String name) {
    if (name.length > 0) {
      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    this.bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    return Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 200,
        child: PieChart(dataMap: dataMap));
  }
}
