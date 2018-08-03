import 'package:flutter/material.dart';
import 'package:gankio/presenter/history_presenter.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> implements HistoryView {
  HistoryPresenter _presenter;

  _HistoryPageState() {
    _presenter = HistoryPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    _presenter.fetchHistory();
    return new Center(
      child: ListView.builder(
          itemCount: 10,
          padding: new EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {
            return new HistoryListItem(
              index: index,
            );
          }),
    );
  }
}

class HistoryListItem extends StatelessWidget {
  HistoryListItem({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 150.0,
      ),
    );
  }
}
