import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:gankio/data/search-result.dart';
import 'package:http/http.dart' as http;

var _bus = EventBus();

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchResultItem> _searchResults = List();

  var _currentKeyword = '';

  _updateResults(List<SearchResultItem> items) {
    setState(() {
      _searchResults.clear();
      _searchResults.addAll(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    var _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print('BOTTOM!!!!');
      }
    });

    var _keywordInputController = TextEditingController(text: _currentKeyword);

    _bus.on<_SearchResultEvent>().listen((event) {
      _updateResults(event.result.results);
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
        title: new Text('检索干货'),
      ),
      body: new Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0, bottom: 8.0),
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _keywordInputController,
                  onFieldSubmitted: (val) {
                    _currentKeyword = _keywordInputController.text;
                    _fetchSearchResult(key: _currentKeyword);
                  },
                  decoration: InputDecoration(hintText: '在此输入关键词~~'),
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
      color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${index + 1}. ${resultItem.desc}',
            style: TextStyle(fontSize: 15.0, color: Colors.black87),
          ),
          Container(
            margin: EdgeInsets.only(top: 2.0),
            child: Text(
              '[${resultItem.type}] By ${resultItem.who} at ${resultItem.publishedAt}',
              style: TextStyle(fontSize: 9.0, color: Colors.brown),
            ),
          ),
        ],
      ),
    );
  }
}

_fetchSearchResult({String key = 'Gank', String category = 'all', int page = 1}) async {
  final response = await http.get("https://gank.io/api/search/query/$key/category/$category/count/50/page/$page");
  if (response.statusCode == 200) {
    _bus.fire(_SearchResultEvent(result: SearchResult.fromJson(response.body)));
  } else {
    throw Exception('Error ${response.statusCode}');
  }
}

class _SearchResultEvent {
  _SearchResultEvent({this.result});

  SearchResult result;
}
