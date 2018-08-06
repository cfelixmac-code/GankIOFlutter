import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:gankio/data/reading_data.dart';
import 'package:gankio/display/reading_category.dart';
import 'package:gankio/presenter/reading_presenter.dart';

var _bus = EventBus();

class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> implements ReadingView {
  var _currentSiteName = '小众软件';
  var _currentSiteId = 'appinn';

  var _currentArticles = List<ReadingArticle>();

  ReadingPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = ReadingPresenter(this);
    _presenter.fetchReadingArticles(_currentSiteId, true);
    _bus.on<ReadingArticlesEvent>().listen((event) {
      setState(() {
        if (this.mounted) {
          if (event.clear) {
            _currentArticles.clear();
          }
          _currentArticles.addAll(event.results);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _articleWidgets = List<Widget>();
    for (var article in _currentArticles) {
      _articleWidgets.add(_buildArticleItem(article));
    }

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Color(0xcc538195),
            height: 60.0,
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _currentSiteName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () async {
                      Map results =
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingCategoryPage()));
                      if (results != null) {
                        setState(() {
                          if (this.mounted) {
                            _currentSiteName = results['siteName'];
                            _currentSiteId = results['siteId'];
                            _presenter.fetchReadingArticles(_currentSiteId, true);
                          }
                        });
                      }
                    },
                    tooltip: '修改分类',
                    icon: Icon(Icons.edit),
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: _articleWidgets,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleItem(ReadingArticle article) {
    return Container(
      height: 60.0,
      padding: EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: '${article.published}\n',
                                style: TextStyle(fontSize: 10.0, color: Colors.blueAccent)),
                            TextSpan(text: article.title, style: TextStyle(fontSize: 13.0, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              color: Colors.transparent,
            ),
          ),
          Container(
            height: 1.0,
            color: Colors.black12,
          )
        ],
      ),
    );
  }

  @override
  fetchReadingArticlesReceived(ReadingArticleResult result, bool clear) {
    if (result != null && result.results != null) {
      _bus.fire(ReadingArticlesEvent(results: result.results, clear: clear));
    }
  }
}
