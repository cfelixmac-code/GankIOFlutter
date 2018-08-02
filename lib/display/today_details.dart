import 'package:flutter/material.dart';
import 'package:gankio/data/article.dart';
import 'package:gankio/display/image_view.dart';
import 'package:gankio/display/web_view.dart';
import 'package:gankio/main.dart';

class TodayDetailDialog extends StatefulWidget {
  TodayDetailDialog(this.article);

  final ArticleSector article;

  @override
  _TodayDetailDialogState createState() => _TodayDetailDialogState(article);
}

class _TodayDetailDialogState extends State<TodayDetailDialog> {
  _TodayDetailDialogState(this._article);

  ArticleSector _article;

  int _imagePagePosition = 1;

  @override
  Widget build(BuildContext context) {
    var imageWidgets = List<Widget>();
    if (_article.images != null && _article.images.length != 0) {
      for (var imgUrl in _article.images) {
        imageWidgets.add(
          Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, GankNavigator(builder: (context) => ImageViewPage(imgUrl)));
                    },
                    child: Image.network(imgUrl),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    var contentWidgets = List<Widget>();
    if (imageWidgets.length != 0) {
      contentWidgets.add(Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          child: PageView(
            onPageChanged: (pos) {
              setState(() {
                _imagePagePosition = pos + 1;
              });
            },
            children: imageWidgets,
          )));
      contentWidgets.add(
        new Center(
          child: Text(
            '$_imagePagePosition/${imageWidgets.length}',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }
    contentWidgets.add(_buildActionButtons(_article));

    return SimpleDialog(
      titlePadding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      contentPadding: EdgeInsets.all(0.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${_article.desc}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
          Text(
            '${_article.url}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
      children: contentWidgets,
    );
  }

  Widget _buildActionButtons(ArticleSector article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            GankNavigator(
                builder: (context) => WebViewer(
                      url: article.url,
                      title: article.desc,
                    )));
      },
      child: Container(
        color: Color(0xFF6791EF),
        margin: EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50.0,
                    padding: EdgeInsets.all(0.0),
                    child: Center(
                      child: Text(
                        '点击查看详情',
                        style: TextStyle(color: Colors.white, fontSize: 16.0, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
