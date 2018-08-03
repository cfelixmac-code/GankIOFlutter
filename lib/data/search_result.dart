import 'dart:convert';

class SearchResult {
  SearchResult({this.count, this.error, this.results});

  int count;
  bool error;
  List<SearchResultItem> results;

  factory SearchResult.fromJson(String raw) {
    var decoded = json.decode(raw);
    List<SearchResultItem> resolvedResults = List();
    for (var rawItem in decoded['results']) {
      resolvedResults.add(SearchResultItem.fromJson(rawItem));
    }
    return SearchResult(count: decoded['count'], error: decoded['error'], results: resolvedResults);
  }
}

class SearchResultItem {
  SearchResultItem({this.desc, this.id, this.publishedAt, this.type, this.url, this.who});

  String desc;
  String id;
  String publishedAt;
  String type;
  String url;
  String who;

  factory SearchResultItem.fromJson(dynamic raw) {
    Map<String, dynamic> rawItem = raw;
    return SearchResultItem(
        desc: rawItem['desc'],
        id: rawItem['ganhuo_id'],
        publishedAt: rawItem['publishedAt'],
        type: rawItem['type'],
        url: rawItem['url'],
        who: rawItem['who']);
  }
}
