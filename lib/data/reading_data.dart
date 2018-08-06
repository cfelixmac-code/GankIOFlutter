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
  ReadingCategory({this.id, this.name, this.enName});

  String id;
  String name;
  String enName;

  factory ReadingCategory.fromJson(dynamic raw) {
    Map<String, dynamic> rawCategory = raw;
    return ReadingCategory(id: rawCategory['_id'], name: rawCategory['name'], enName: rawCategory['en_name']);
  }
}

class ReadingSiteResult {
  ReadingSiteResult({this.error, this.results});

  bool error;
  List<ReadingSite> results;

  factory ReadingSiteResult.fromJson(String raw) {
    var decoded = json.decode(raw);
    var results = List<ReadingSite>();
    for (var rawSite in decoded['results']) {
      results.add(ReadingSite.fromJson(rawSite));
    }
    return ReadingSiteResult(error: decoded['error'], results: results);
  }
}

class ReadingSite {
  ReadingSite({this.id, this.title, this.icon});

  String id;
  String icon;
  String title;

  factory ReadingSite.fromJson(dynamic raw) {
    Map<String, dynamic> rawSite = raw;
    return ReadingSite(id: rawSite['id'], icon: rawSite['icon'], title: rawSite['title']);
  }
}
