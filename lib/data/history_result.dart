import 'dart:convert';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class HistoryResult {
  HistoryResult({this.error, this.results});

  bool error;

  List<HistoryResultItem> results;

  factory HistoryResult.fromJson(String raw) {
    var decoded = json.decode(raw);
    var results = List<HistoryResultItem>();
    for (var rawItem in decoded['results']) {
      results.add(HistoryResultItem.fromJson(rawItem));
    }
    return HistoryResult(error: decoded['error'], results: results);
  }
}

class HistoryResultItem {
  HistoryResultItem({this.id, this.sections, this.publishedAt, this.title});

  String id;
  String publishedAt;
  String title;

  List<HistoryArticleSection> sections;

  factory HistoryResultItem.fromJson(dynamic raw) {
    String id = raw['_id'];
    var resolvedSections = List<HistoryArticleSection>();

    Document document = parse(raw['content']);

    HistoryArticleSection section;
    bool isSectionValid = false;
    for (Node node in document.body.nodes) {
      try {
        if (node.toString() == '<html h3>') {
          section = new HistoryArticleSection();
          isSectionValid = true;
          section.name = node.text;
        }

        if (section != null && node.toString() == '<html ul>') {
          section.articles = List();
          for (var liItem in node.nodes) {
            if (liItem.toString() == '<html li>') {
              String value = "";
              HistoryArticle article = HistoryArticle();

              for (var liItemChild in liItem.nodes) {
                if (liItemChild.text != null && liItemChild.text.trim().length != 0) {
                  if (article.url == null &&
                      liItemChild.attributes['href'] != null &&
                      liItemChild.attributes['href'].length != 0) {
                    article.url = liItemChild.attributes['href'].trim();
                  }
                  String currentText = liItemChild.text.trim();
                  value += currentText;
                }
              }
              article.title = value;

              section.articles.add(article);
            }
          }
        }
        if (section != null && isSectionValid) {
          resolvedSections.add(section);
          isSectionValid = false;
        }
      } catch (e) {}
    }
    return HistoryResultItem(id: id, sections: resolvedSections, publishedAt: raw['publishedAt'], title: raw['title']);
  }
}

class HistoryArticleSection {
  HistoryArticleSection({this.name, this.articles});

  String name;
  List<HistoryArticle> articles;
}

class HistoryArticle {
  HistoryArticle({this.title, this.url});

  String title;
  String url;
}
