import 'package:gankio/data/reading_data.dart';
import 'package:http/http.dart' as http;

abstract class ReadingCategoryView {
  fetchCategoryReceived(ReadingCategoryResult result);

  fetchSitesReceived(ReadingSiteResult result);
}

abstract class ReadingView {
  fetchReadingArticlesReceived(ReadingArticleResult result, bool clear);
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

  fetchReadingArticles(String site, bool clear) async {
    final response = await http.get("https://gank.io/api/xiandu/data/id/$site/count/15/page/1");
    if (response.statusCode == 200 && _readingView != null) {
      _readingView.fetchReadingArticlesReceived(ReadingArticleResult.fromJson(response.body), clear);
    } else {
      throw Exception('fetchReadingArticles-$site-Error ${response.statusCode}');
    }
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
