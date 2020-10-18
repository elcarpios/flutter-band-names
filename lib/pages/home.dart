import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 1),
    Band(id: '2', name: 'Bon Jovi', votes: 1),
    Band(id: '3', name: 'Amaral', votes: 2),
    Band(id: '4', name: 'Héroes del silence', votes: 3)
  ];

  Color primaryColor = Colors.red[600];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) =>
              _buildBandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
        elevation: 5,
      ),
    );
  }

  Dismissible _buildBandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {},
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
        onTap: () {
          print('onTap: ${band.name}');
        },
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
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
