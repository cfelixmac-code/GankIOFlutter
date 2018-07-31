import 'package:flutter/material.dart';

class GanhuoPage extends StatefulWidget {
  @override
  _GanhuoPageState createState() => new _GanhuoPageState();
}

class _GanhuoPageState extends State<GanhuoPage> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: ListView.builder(
          padding: new EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {
            return new GanhuoListItem(
              index: index,
            );
          }),
    );
  }
}

class GanhuoListItem extends StatelessWidget {
  GanhuoListItem({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 88.0,
      color: index % 2 == 1 ? Colors.deepPurpleAccent : Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                child: new Text(
                  'This is Daily Title by $index',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
