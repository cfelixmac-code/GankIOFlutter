import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:gankio/data/reading_data.dart';
import 'package:gankio/display/reading_category.dart';
import 'package:gankio/display/web_view.dart';
import 'package:gankio/main.dart';
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
  var _isListEnd = false;

  ReadingPresenter _presenter;

  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _presenter = ReadingPresenter(this);
    _presenter.fetchReadingArticles(_currentSiteId, true);
    _bus.on<ReadingArticlesEvent>().listen((event) {
      if (this.mounted) {
        setState(() {
          if (event.clear) {
            _currentArticles.clear();
          }
          _currentArticles.addAll(event.results);
        });
      }
    });
    _bus.on<ReadingArticlesEndEvent>().listen((event) {
      if (this.mounted) {
        setState(() {
          _isListEnd = true;
        });
      }
    });

    _scrollController.addListener(() {
      if (!_isListEnd && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.fetchReadingArticles(_currentSiteId, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _articleWidgets = List<Widget>();
    for (var article in _currentArticles) {
      _articleWidgets.add(_buildArticleItem(article));
    }
    if (!_isListEnd) {
      _articleWidgets.add(_buildArticleLoading());
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
                            _isListEnd = false;
                            _currentArticles.clear();
                            _currentSiteName = results['siteName'];
                            _currentSiteId = results['siteId'];
                            _scrollController.jumpTo(0.0);
                            _presenter.handleSiteChange();
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
              controller: _scrollController,
              children: _articleWidgets,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleLoading() {
    return Container(
      height: 60.0,
      child: Center(
        child: Container(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
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
                onTap: () {
                  Navigator.push(
                      context,
                      GankNavigator(
                          builder: (context) => WebViewPage(
                                article.url,
                              )));
                },
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
    _bus.fire(ReadingArticlesEvent(results: result.results, clear: clear));
  }

  @override
  fetchReadingArticlesEnd() {
    _bus.fire(ReadingArticlesEndEvent());
  }
}
