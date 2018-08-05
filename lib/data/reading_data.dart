import 'dart:convert';

class ReadingCategoryResult {
  ReadingCategoryResult({this.error, this.results});

  bool error;

  List<ReadingCategory> results;

  factory ReadingCategoryResult.fromJson(String raw) {
    var decoded = json.decode(raw);
    var results = List<ReadingCategory>();
    for (var rawCategory in decoded['results']) {
      results.add(ReadingCategory.fromJson(rawCategory));
    }
    return ReadingCategoryResult(error: decoded['error'], results: results);
  }
}

class ReadingCategory {
  ReadingCategory({this.id, this.name});

  String id;
  String name;

  factory ReadingCategory.fromJson(dynamic raw) {
    Map<String, dynamic> rawCategory = raw;
    return ReadingCategory(id: rawCategory['id'], name: rawCategory['name']);
  }
}
