import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:gankio/data/history_result.dart';
import 'package:gankio/presenter/history_presenter.dart';

var _bus = EventBus();

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> implements HistoryView {
  HistoryPresenter _presenter;

  var _data = List<HistoryResultItem>();

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
    _presenter.fetchHistory();
    _bus.on<HistoryResultEvent>().listen((event) {
      _updateResults(event.result);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.length != 0) {
      return Center(
        child: ListView.builder(
          padding: EdgeInsets.all(3.0),
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return HistoryListItem(_data[index]);
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
    _bus.fire(HistoryResultEvent(result: result));
  }
}

class HistoryListItem extends StatelessWidget {
  HistoryListItem(this.item);

  final HistoryResultItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${item.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 17.0, color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              ' ${item.publishedAt.length > 10 ? item.publishedAt.substring(0, 10) : item.publishedAt}',
              style: TextStyle(fontSize: 10.0, color: Colors.blueAccent, fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              child: Container(
                height: 80.0,
                color: Colors.red,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
