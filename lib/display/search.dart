import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gankio/data/search_result.dart';
import 'package:gankio/display/web_view.dart';
import 'package:gankio/main.dart';
import 'package:http/http.dart' as http;

var _bus = EventBus();

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchResultItem> _searchResults = List();

  var _currentKeyword = '';
  var _page = 1;

  var _pageTitle = '搜索干货';

  _updateResults(List<SearchResultItem> items, bool clear) {
    if (this.mounted) {
      setState(() {
        if (clear) _searchResults.clear();
        _searchResults.addAll(items);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _keywordInputController = TextEditingController(text: _currentKeyword);
    var _requesting = false;
    var _endList = false;

    var _scrollController = ScrollController();

    _bus.on<_SearchResultEvent>().listen((event) {
      _requesting = false;
      if (event.result.results != null && event.result.results.length != 0) {
        _updateResults(event.result.results, event.clear);
      } else {
        _endList = true;
      }
    });

    _startSearch(bool clear) {
      if (clear) {
        _endList = false;
        _scrollController.jumpTo(0.0);
      }
      if (!_endList) {
        _currentKeyword = _keywordInputController.text;
        if (_currentKeyword != null && _currentKeyword.length != 0) {
          _pageTitle = '搜索干货：$_currentKeyword';
          _requesting = true;
          _fetchSearchResult(key: _currentKeyword, page: _page, clear: clear);
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
      }
    }

    _scrollController.addListener(() {
      if (!_requesting && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _page++;
        _startSearch(false);
      }
    });

    ListView _buildListView() {
      return ListView.builder(
          controller: _scrollController,
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            return _buildItemView(_searchResults[index], index);
          });
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_pageTitle),
      ),
      body: new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0, bottom: 8.0),
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        controller: _keywordInputController,
                        onFieldSubmitted: (val) {
                          _startSearch(true);
                        },
                        decoration: InputDecoration(hintText: '在此输入关键词~~'),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _startSearch(true);
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: _buildListView(),
              )
            ],
          )),
    );
  }

  Widget _buildItemView(SearchResultItem resultItem, int index) {
    return Container(
      margin: EdgeInsets.only(top: 3.5, bottom: 3.5),
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 2.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewer(
                        url: resultItem.url,
                        title: resultItem.desc,
                      )));
        },
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  GankNavigator(
                      builder: (context) => WebViewer(
                            url: resultItem.url,
                            title: resultItem.desc,
                          )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${index + 1}. ${resultItem.desc}'.trim(),
                  style: TextStyle(fontSize: 15.2, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: EdgeInsets.only(top: 3.0),
                  child: Text(
                    '[${resultItem.type}] By ${resultItem.who} at ${resultItem.publishedAt}',
                    style: TextStyle(fontSize: 9.0, color: Colors.grey[500]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.5),
                  color: Colors.black12,
                  height: 1.5,
                )
              ],
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}

_fetchSearchResult({String key = 'Gank', String category = 'all', int page = 1, bool clear = false}) async {
  final response = await http.get("https://gank.io/api/search/query/$key/category/$category/count/30/page/$page");
  if (response.statusCode == 200) {
    _bus.fire(_SearchResultEvent(result: SearchResult.fromJson(response.body), clear: clear));
  } else {
    throw Exception('Search-Error ${response.statusCode}');
  }
}

class _SearchResultEvent {
  _SearchResultEvent({this.result, this.clear});

  SearchResult result;

  bool clear = false;
}
