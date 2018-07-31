import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('检索干货'),
      ),
      body: new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0, bottom: 8.0),
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  onFieldSubmitted: (val) {
                    print('Keyword Submit');
                  },
                  decoration: InputDecoration(hintText: '在此输入关键词~~'),
                ),
              ),
            ],
          )),
    );
  }
}
