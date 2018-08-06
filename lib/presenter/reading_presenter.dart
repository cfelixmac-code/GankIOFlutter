import 'package:gankio/data/reading_data.dart';
import 'package:http/http.dart' as http;

abstract class ReadingCategoryView {
  fetchCategoryReceived(ReadingCategoryResult result);

  fetchSitesReceived(ReadingSiteResult result);
}

abstract class ReadingView {
  fetchReadingArticlesReceived(ReadingArticleResult result, bool clear);

  fetchReadingArticlesEnd();
}

class ReadingCategoryPresenter {
  ReadingCategoryPresenter(this._categoryView);

  final ReadingCategoryView _categoryView;

  fetchCategory() async {
    final response = await http.get("https://gank.io/api/xiandu/categories");
    if (response.statusCode == 200 && _categoryView != null) {
      _categoryView.fetchCategoryReceived(ReadingCategoryResult.fromJson(response.body));
    } else {
      throw Exception('fetchCategory-Error ${response.statusCode}');
    }
  }

  fetchSites(String category) async {
    final response = await http.get("https://gank.io/api/xiandu/category/$category");
    if (response.statusCode == 200 && _categoryView != null) {
      _categoryView.fetchSitesReceived(ReadingSiteResult.fromJson(response.body));
    } else {
      throw Exception('fetchSites-$category-Error ${response.statusCode}');
    }
  }
}

class ReadingPresenter {
  ReadingPresenter(this._readingView);

  final ReadingView _readingView;

  var _page = 1;
  var _requesting = false;

  fetchReadingArticles(String site, bool clear) async {
    if (!_requesting) {
      if (!clear) _page++;
      _requesting = true;
      final response = await http.get("https://gank.io/api/xiandu/data/id/$site/count/25/page/$_page");
      if (response.statusCode == 200 && _readingView != null) {
        _requesting = false;
        ReadingArticleResult result = ReadingArticleResult.fromJson(response.body);
        if (result != null && result.results != null && result.results.length != 0) {
          _readingView.fetchReadingArticlesReceived(result, clear);
        } else {
          _readingView.fetchReadingArticlesEnd();
        }
      } else {
        throw Exception('fetchReadingArticles-$site-Error ${response.statusCode}');
      }
    }
  }

  handleSiteChange() {
    _page = 1;
    _requesting = false;
  }
}

class ReadingCategoryEvent {
  ReadingCategoryEvent({this.categories});

  List<ReadingCategory> categories;
}

class ReadingSiteEvent {
  ReadingSiteEvent({this.sites});

  List<ReadingSite> sites;
}

class ReadingCategorySwitchEvent {
  ReadingCategorySwitchEvent(this.category);

  ReadingCategory category;
}

class ReadingArticlesEvent {
  ReadingArticlesEvent({this.results, this.clear = false});

  bool clear;
  List<ReadingArticle> results;
}

class ReadingArticlesEndEvent {}
