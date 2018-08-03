import 'package:event_bus/event_bus.dart';
import 'package:gankio/data/history_result.dart';
import 'package:http/http.dart' as http;

abstract class HistoryView {}

var _bus = EventBus();

class HistoryPresenter {
  HistoryPresenter(this._view);

  final HistoryView _view;

  fetchHistory({int page = 1}) async {
    final response = await http.get("https://gank.io/api/history/content/10/$page");
    if (response.statusCode == 200) {
      _bus.fire(_HistoryResultEvent(result: HistoryResult.fromJson(response.body)));
    } else {
      throw Exception('Error ${response.statusCode}');
    }
  }
}

class _HistoryResultEvent {
  _HistoryResultEvent({this.result});

  HistoryResult result;
}
