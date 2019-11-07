import 'package:flutter/material.dart';
import 'package:maps_devfest/ui/home.dart';

void main() => runApp(MapsDevfest());

class MapsDevfest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devfest Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}