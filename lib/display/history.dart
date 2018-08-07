import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:gankio/data/history_result.dart';
import 'package:gankio/display/history_details.dart';
import 'package:gankio/presenter/history_presenter.dart';

var _bus = EventBus();

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> implements HistoryView {
  HistoryPresenter _presenter;

  var _data = List<HistoryResultItem>();
  var _pageIndex = 1;
  var _requesting = false;
  var _end = false;

  _HistoryPageState() {
    _presenter = HistoryPresenter(this);
  }

  _updateResults(HistoryResult result) {
    if (this.mounted) {
      setState(() {
        _data.addAll(result.results);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _presenter.fetchHistory(page: _pageIndex);
    _bus.on<HistoryResultEvent>().listen((event) {
      _requesting = false;
      _updateResults(event.result);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (!_requesting && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _pageIndex++;
        _requesting = true;
        _presenter.fetchHistory(page: _pageIndex);
      }
    });

    if (_data.length != 0) {
      return Center(
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(3.0),
          itemCount: _end ? _data.length : _data.length + 1,
          itemBuilder: (context, index) {
            if (index < _data.length) {
              return HistoryListItem(_data[index]);
            } else {
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
          },
        ),
      );
    } else {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.08,
          height: MediaQuery.of(context).size.width * 0.08,
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  @override
  fetchReceived(HistoryResult result) {
    if (result.results != null && result.results.length != 0) {
      _bus.fire(HistoryResultEvent(result: result));
    } else {
      _end = true;
    }
  }
}

class HistoryListItem extends StatelessWidget {
  HistoryListItem(this.item);

  final HistoryResultItem item;

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>();
    widgets.add(Text(
      '${item.title}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 17.0, color: Colors.black87, fontWeight: FontWeight.w600),
    ));
    widgets.add(Text(
      ' ${item.publishedAt.length > 10 ? item.publishedAt.substring(0, 10) : item.publishedAt}',
      style: TextStyle(fontSize: 10.0, color: Colors.blueAccent, fontWeight: FontWeight.w500),
    ));
    String content = '';
    for (HistoryArticleSection section in item.sections) {
      if (section.articles != null) {
        for (HistoryArticle article in section.articles) {
          content += article.title.substring(0, article.title.lastIndexOf('(')).trim();
          content += '  ';
        }
      }
    }
    widgets.add(Container(
      child: Text(
        content,
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13.3,
          color: Colors.black54,
        ),
      ),
    ));
    widgets.add(Container(
      margin: EdgeInsets.only(top: 8.0),
      child: MaterialButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return HistoryDetailDialog(item);
              });
        },
        color: Colors.blueAccent,
        child: Text(
          '详情',
          style: TextStyle(fontSize: 13.0, color: Colors.white, letterSpacing: 1.0),
        ),
      ),
      alignment: Alignment.topRight,
    ));

    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }
}
