import 'package:flutter/material.dart';

class FuliPage extends StatefulWidget {
  @override
  _FuliPageState createState() => new _FuliPageState();
}

class _FuliPageState extends State<FuliPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: ListView.builder(
          padding: new EdgeInsets.all(8.0),
          itemExtent: 40.0,
          itemBuilder: (BuildContext context, int index) {
            return new Text('entry_Fuli_$index');
          }),
    );
  }
}
