import 'dart:async';
import 'dart:convert';
import 'package:gankio/data/rest_frame.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {


    return FutureBuilder<RestFrame>(
      future: fetchPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.category.toString());
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner
        return CircularProgressIndicator();
      },
    );




    Image image = new Image.network('https://ww1.sinaimg.cn/large/0065oQSqgy1ftrrvwjqikj30go0rtn2i.jpg');
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image
        .resolve(new ImageConfiguration())
        .addListener((ImageInfo info, bool _) => completer.complete(info.image));

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Title~'),
          new FutureBuilder<ui.Image>(
            future: completer.future,
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              if (snapshot.hasData) {
                double imageWidthDefine = MediaQuery.of(context).size.width * 0.65;
                return new Container(
                  width: imageWidthDefine,
                  height: imageWidthDefine / snapshot.data.width * snapshot.data.height,
                  child: image,
                );
              } else {
                return new Text('Loading...');
              }
            },
          ),
        ],
      ),
    );
  }
}

//Future<http.Response> fetchPost() {
//  return http.get('https://jsonplaceholder.typicode.com/posts/1');
//}

Future<RestFrame> fetchPost() async {
  final response = await http.get('https://gank.io/api/today');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return RestFrame.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}
