import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gankio/data/article.dart';
import 'package:gankio/display/web_viewer.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article>(
      future: _fetchHomePage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _generateContent(snapshot.data, context);
        } else if (snapshot.hasError) {
          return new Center(
            child: Text("${snapshot.error}"),
          );
        }
        return new Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
          child: Center(
            child: CircularProgressIndicator(), // By default, show a loading spinner
          ),
        );
      },
    );
  }
}

Widget _generateContent(Article article, BuildContext context) {
  List<Widget> items = new List();
  // ==============> Title
  items.add(FutureBuilder<dom.Document>(
    future: _fetchHtml(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        for (var node in snapshot.data.head.nodes) {
          if (node != null && node.toString() == '<html title>') {
            return _generateTitle(node.text);
          }
        }
      }
      return _generateTitle("Gank IO~");
    },
  ));
  // ==============> RequestTime
  items.add(
    new Container(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          "请求时间：${ DateTime.now().toString()}",
          style: TextStyle(fontSize: 10.0, color: Colors.black45),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
  );
  // =================> App Content
  items.add(_generateSectionTitle('App'));
  items.add(_generateHorizontalLine());
  for (var sector in article.result['App']) {
    _generateArticleDesc(items, sector, context);
  }
  // =================> Android Content
  items.add(_generateSectionTitle('Android'));
  items.add(_generateHorizontalLine());
  for (var sector in article.result['Android']) {
    _generateArticleDesc(items, sector, context);
  }
  // =================> iOS Content
  items.add(_generateSectionTitle('iOS'));
  items.add(_generateHorizontalLine());
  for (var sector in article.result['iOS']) {
    _generateArticleDesc(items, sector, context);
  }
  // =================> QianDuan Content
  items.add(_generateSectionTitle('前端'));
  items.add(_generateHorizontalLine());
  for (var sector in article.result['前端']) {
    _generateArticleDesc(items, sector, context);
  }
  // =================> TuoZhan Content
  items.add(_generateSectionTitle('拓展资源'));
  items.add(_generateHorizontalLine());
  for (var sector in article.result['拓展资源']) {
    _generateArticleDesc(items, sector, context);
  }
  // =================> XiuXi Content
  items.add(_generateSectionTitle('休息视频'));
  items.add(_generateHorizontalLine());
  for (var sector in article.result['休息视频']) {
    _generateArticleDesc(items, sector, context);
  }
  // ==============> FuLi Image
  items.add(_generateSectionTitle('福利'));
  items.add(_generateHorizontalLine());
  String fuLiUrl =
      (article.result['福利'] != null && article.result['福利'].length > 0) ? article.result['福利'][0].url : null;
  if (fuLiUrl != null) {
    Image image = new Image.network(article.result['福利'][0].url);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image
        .resolve(new ImageConfiguration())
        .addListener((ImageInfo info, bool _) => completer.complete(info.image));
    items.add(new FutureBuilder<ui.Image>(
      future: completer.future,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData) {
          double imageWidthDefine = MediaQuery.of(context).size.width * 0.5;
          return new Container(
            margin: EdgeInsets.only(top: 3.0, bottom: 10.0),
            width: imageWidthDefine,
            height: imageWidthDefine / snapshot.data.width * snapshot.data.height,
            child: image,
          );
        } else {
          return new Text('Loading...');
        }
      },
    ));
  } else {
    items.add(new Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Text(
        '今天没有福利~QAQ~',
        style: TextStyle(fontSize: 15.0),
      ),
    ));
  }

  return ListView(
    padding: new EdgeInsets.only(left: 15.0, right: 15.0),
    children: items,
  );
}

Widget _generateTitle(String text) {
  return new Container(
    padding: EdgeInsets.only(top: 5.0, bottom: 2.0),
    child: new Text(
      text,
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _generateSectionTitle(String text) {
  return new Text(
    text,
    style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold, color: Colors.blueGrey),
  );
}

_generateArticleDesc(List<Widget> items, ArticleSector sector, BuildContext context) {
  items.add(new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewer(
                      url: sector.url,
                      title: sector.desc,
                    )));
      },
      child: new Container(
        margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
        padding: EdgeInsets.only(left: 2.0, right: 2.0, top: 12.0, bottom: 12.0),
        color: Colors.black12,
        child: new RichText(
            text: new TextSpan(style: new TextStyle(fontSize: 13.0), children: <TextSpan>[
          new TextSpan(text: sector.desc, style: new TextStyle(color: Colors.black)),
          new TextSpan(text: "    —— ${sector.who}", style: new TextStyle(color: Colors.brown, fontSize: 10.0))
        ])),
      )));
}

Widget _generateHorizontalLine() {
  return new Container(
    height: 1.0,
    color: Colors.blueGrey,
  );
}

Future<Article> _fetchHomePage() async {
  final response = await http.get('https://gank.io/api/today');
  if (response.statusCode == 200) {
    return Article.fromJson(response.body);
  } else {
    throw Exception('Failed to HomePage');
  }
}

Future<dom.Document> _fetchHtml() async {
  final response = await http.get('https://gank.io');
  if (response.statusCode == 200) {
    return parse(response.body);
  } else {
    throw Exception('Failed to HomeHtml');
  }
}
