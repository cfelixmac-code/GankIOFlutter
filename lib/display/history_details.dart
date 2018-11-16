import 'package:flutter/material.dart';
import 'package:gankio/data/history_result.dart';
import 'package:gankio/display/web_view.dart';
import 'package:gankio/main.dart';

class HistoryDetailDialog extends StatefulWidget {
  HistoryDetailDialog(this.article);

  final HistoryResultItem article;

  @override
  _HistoryDetailDialogState createState() => _HistoryDetailDialogState(article);
}

class _HistoryDetailDialogState extends State<HistoryDetailDialog> {
  _HistoryDetailDialogState(this._item);

  HistoryResultItem _item;

  @override
  Widget build(BuildContext context) {
    var contentWidgets = List<Widget>();
    for (HistoryArticleSection section in _item.sections) {
      if (section.articles != null && section.articles.length != 0) {
        for (HistoryArticle article in section.articles) {
          contentWidgets.add(_buildItem(section.name, article));
        }
      }
    }

    return SimpleDialog(
      titlePadding: EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0),
      contentPadding: EdgeInsets.only(bottom: 12.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${(_item.publishedAt != null && _item.publishedAt.length > 10) ? _item.publishedAt.substring(0, 10) : _item
                .publishedAt}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${_item.title}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      children: contentWidgets,
    );
  }

  Widget _buildItem(String sectionName, HistoryArticle article) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            GankNavigator(
                builder: (context) => WebViewPage(
                      article.url,
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        height: 52.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildItemTextWidget(sectionName, article),
          ],
        ),
      ),
    );
  }

  Expanded _buildItemTextWidget(String sectionName, HistoryArticle article) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '[$sectionName] ',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${article.title}',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Color(0xff464646),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
