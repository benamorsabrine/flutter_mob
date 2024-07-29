import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FieldTicket(),
    );
  }
}

class FieldTicket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page daccueil'),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur Field Ticket!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}