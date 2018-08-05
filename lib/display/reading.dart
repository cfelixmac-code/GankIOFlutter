import 'package:flutter/material.dart';
import 'package:gankio/display/reading_category.dart';
import 'package:gankio/main.dart';

class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            height: MediaQuery.of(context).size.width * 0.25,
            width: MediaQuery.of(context).size.width * 0.25,
            child: ListView(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.ac_unit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          GankNavigator(
                            builder: (context) => ReadingCategoryPage(),
                          ));
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
