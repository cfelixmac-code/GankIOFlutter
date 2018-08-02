import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gankio/data/article.dart';
import 'package:gankio/display/today_details.dart';
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
    return Container(
      color: const Color(0x99D9DAE4),
      child: FutureBuilder<Article>(
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
      ),
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
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(
          "请求时间：${ DateTime.now().toString()}",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 10.0, color: const Color(0xFF747474)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
  );

  // =================> App Content
  var appArticles = article.result['App'];
  if (appArticles != null && appArticles.length != 0) {
    items.add(_buildArticlesBlock(title: 'App', icon: 'images/app_icon.png', articles: appArticles, context: context));
    items.add(_buildSectionSpace());
  }
  // =================> Android Content
  var androidArticles = article.result['Android'];
  if (androidArticles != null && androidArticles.length != 0) {
    items
        .add(_buildArticlesBlock(title: 'Android', icon: 'images/android_icon.png', articles: androidArticles, context: context));
    items.add(_buildSectionSpace());
  }
  // =================> iOS Content
  var iOSArticles = article.result['iOS'];
  if (iOSArticles != null && iOSArticles.length != 0) {
    items.add(_buildArticlesBlock(title: 'iOS', icon: 'images/ios_icon.png', articles: iOSArticles, context: context));
    items.add(_buildSectionSpace());
  }
  // =================> QianDuan Content
  var frontArticles = article.result['前端'];
  if (frontArticles != null && frontArticles.length != 0) {
    items.add(_buildArticlesBlock(title: '前端', icon: 'images/front_icon.png', articles: frontArticles, context: context));
    items.add(_buildSectionSpace());
  }
  // =================> TuoZhan Content
  var extendArticles = article.result['拓展资源'];
  if (extendArticles != null && extendArticles.length != 0) {
    items.add(_buildArticlesBlock(title: '拓展资源', icon: 'images/extend_icon.png', articles: extendArticles, context: context));
    items.add(_buildSectionSpace());
  }
  // =================> XiuXi Content
  var relaxArticles = article.result['休息视频'];
  if (relaxArticles != null && relaxArticles.length != 0) {
    items.add(_buildArticlesBlock(title: '休息视频', icon: 'images/relax_icon.png', articles: relaxArticles, context: context));
    items.add(_buildSectionSpace());
  }
  // ==============> FuLi Image
  String fuLiUrl = (article.result['福利'] != null && article.result['福利'].length > 0) ? article.result['福利'][0].url : null;
  if (fuLiUrl != null) {
    items.add(new Card(
      child: Container(
        height: 42.0,
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return ProfitImageDialog(fuLiUrl);
                });
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text(
                              '~今日妹子~',
                              maxLines: 1,
                              style: TextStyle(fontSize: 12.0, color: Colors.black38, letterSpacing: 3.0),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    ));
    items.add(Container(
      height: 12.0,
    ));
  }

  return ListView(
    padding: new EdgeInsets.only(left: 15.0, right: 15.0),
    children: items,
  );
}

Widget _buildSectionSpace() {
  return Container(
    height: 10.0,
  );
}

Widget _generateTitle(String text) {
  return new Container(
    padding: EdgeInsets.only(top: 15.0, bottom: 2.0),
    child: new Text(
      text,
      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: const Color(0xFF747474)),
    ),
  );
}

Widget _buildArticlesBlock({String title, String icon, List<ArticleSector> articles, BuildContext context}) {
  var articleItems = List<Widget>();
  articleItems.add(Container(
    height: 3.0,
  ));
  articleItems.add(_buildArticlesBlockTitle(title: title, icon: icon));
  articleItems.add(Container(
    height: 5.0,
  ));
  for (var sector in articles) {
    articleItems.add(_buildArticleItem(sector, context));
  }
  Color color = Colors.black26;
  switch (title) {
    case 'App':
      color = Colors.blueAccent;
      break;
    case 'iOS':
      color = Colors.deepPurpleAccent;
      break;
    case 'Android':
      color = Colors.lightGreen;
      break;
    case '前端':
      color = Colors.brown;
      break;
    case '拓展资源':
      color = Colors.blueGrey;
      break;
    case '休息视频':
      color = Colors.teal;
      break;
  }
  return Card(
    child: Container(
      color: color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 5.0,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: articleItems,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _buildArticlesBlockTitle({String title, String icon}) {
  return Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 6.0),
        padding: EdgeInsets.all(0.0),
        width: 24.0,
        height: 24.0,
        child: Image.asset(icon),
      ),
      Text(
        '  $title',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: const Color(0xFF515151)),
      ),
    ],
  );
}

Widget _buildArticleItem(ArticleSector article, BuildContext context) {
  return Material(
    child: InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return TodayDetailDialog(article);
            });
      },
      child: Container(
        padding: EdgeInsets.only(left: 18.0, top: 10.0, right: 3.0, bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 3.5, right: 6.0),
                child: Image.asset('images/doc_icon.png'),
                width: 15.0,
                height: 15.0,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: Text(
                        '${article.desc.trim()}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.0, color: Color(0xFF555555)),
                      )),
                  Container(
                    child: Text(
                      '${article.who} 发布于 ${article.publishedAt.substring(0, 10)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 9.0, color: Colors.black45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    color: Colors.transparent,
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

//  /////////// IMAGE REQUEST NOTE ///////////////////
//
//  items.add(_generateSectionTitle('福利'));
//  items.add(_generateHorizontalLine());
//  String fuLiUrl = (article.result['福利'] != null && article.result['福利'].length > 0) ? article.result['福利'][0].url : null;
//  if (fuLiUrl != null) {
//    Image image = new Image.network(article.result['福利'][0].url);
//    Completer<ui.Image> completer = new Completer<ui.Image>();
//    image.image.resolve(new ImageConfiguration()).addListener((ImageInfo info, bool _) => completer.complete(info.image));
//    items.add(new FutureBuilder<ui.Image>(
//      future: completer.future,
//      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
//        if (snapshot.hasData) {
//          double imageWidthDefine = MediaQuery.of(context).size.width * 0.5;
//          return new Container(
//            margin: EdgeInsets.only(top: 3.0, bottom: 10.0),
//            width: imageWidthDefine,
//            height: imageWidthDefine / snapshot.data.width * snapshot.data.height,
//            child: image,
//          );
//        } else {
//          return new Text('Loading...');
//        }
//      },
//    ));
//  } else {
//    items.add(new Container(
//      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
//      child: Text(
//        '今天没有福利~QAQ~',
//        style: TextStyle(fontSize: 15.0),
//      ),
//    ));
//  }
