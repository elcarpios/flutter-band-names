import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/pages/home.dart';
import 'package:band_names/pages/status.dart';

import 'package:band_names/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (context) => HomePage(),
          'status': (context) => StatusPage()
        },
      ),
    );
  }
}
