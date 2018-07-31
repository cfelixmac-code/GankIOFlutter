import 'package:flutter/material.dart';

class XianduPage extends StatefulWidget {
  @override
  _XianduPageState createState() => new _XianduPageState();
}

class _XianduPageState extends State<XianduPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: ListView.builder(
          padding: new EdgeInsets.all(8.0),
          itemExtent: 40.0,
          itemBuilder: (BuildContext context, int index) {
            return new Text('entry_Xiandu_$index');
          }),
    );
  }
}
