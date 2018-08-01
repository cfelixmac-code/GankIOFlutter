import 'dart:convert';

class Article {
  Article({this.category, this.error, this.result});

  List<String> category;
  bool error;
  Map<String, List<ArticleSector>> result;

  factory Article.fromJson(String bodyString) {
    Map<String, dynamic> body = json.decode(bodyString);
    Map<String, List<ArticleSector>> results = Map();
    Map<String, dynamic> rawResults = body['results'];

    results['App'] = parseSectors("App", rawResults);
    results['iOS'] = parseSectors("iOS", rawResults);
    results['Android'] = parseSectors("Android", rawResults);
    results['休息视频'] = parseSectors("休息视频", rawResults);
    results['前端'] = parseSectors("前端", rawResults);
    results['拓展资源'] = parseSectors("拓展资源", rawResults);
    results['瞎推荐'] = parseSectors("瞎推荐", rawResults);
    results['福利'] = parseSectors("福利", rawResults);

    return Article(
      category: new List<String>.from(body['category']),
      error: body['error'],
      result: results,
    );
  }
}

List<ArticleSector> parseSectors(String key, Map<String, dynamic> rawResults) {
  List<dynamic> raw = rawResults[key];
  List<ArticleSector> result = List();
  if (raw != null && raw.length != 0) {
    for (var article in raw) {
      result.add(ArticleSector.fromJson(article));
    }
  }
  return result;
}

class ArticleSector {
  ArticleSector({this.createdAt, this.desc, this.images, this.publishedAt, this.url, this.who});

  String createdAt;
  String desc;
  List<String> images;
  String publishedAt;
  String url;
  String who;

  factory ArticleSector.fromJson(dynamic jsonString) {
    Map<String, dynamic> raw = jsonString;
    return new ArticleSector(
      createdAt: raw['createdAt'],
      desc: raw['desc'],
      images: (raw.containsKey('images') && raw['images'] != null) ? new List<String>.from(raw['images']) : null,
      publishedAt: raw['publishedAt'],
      url: raw['url'],
      who: raw['who'],
    );
  }
}
