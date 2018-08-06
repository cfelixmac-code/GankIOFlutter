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

  bool selected = false;

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

class ReadingArticleResult {
  ReadingArticleResult({this.error, this.results});

  bool error;
  List<ReadingArticle> results;

  factory ReadingArticleResult.fromJson(String raw) {
    var decoded = json.decode(raw);
    var results = List<ReadingArticle>();
    for (var rawArticle in decoded['results']) {
      results.add(ReadingArticle.fromJson(rawArticle));
    }
    return ReadingArticleResult(error: decoded['error'], results: results);
  }
}

class ReadingArticle {
  ReadingArticle({this.url, this.title, this.published, this.author});

  String url;

  String title;

  String published;

  String author;

  factory ReadingArticle.fromJson(dynamic raw) {
    String publishTime = raw['published_at'];
    publishTime = (publishTime != null && publishTime.length > 10) ? publishTime.substring(0, 10) : publishTime;

    return ReadingArticle(url: raw['url'], title: raw['title'], published: publishTime);
  }
}
