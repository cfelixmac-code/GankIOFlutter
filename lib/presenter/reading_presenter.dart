import 'package:gankio/data/reading_data.dart';
import 'package:http/http.dart' as http;

abstract class ReadingCategoryView {
  fetchCategoryReceived(ReadingCategoryResult result);

  fetchSitesReceived(ReadingSiteResult result);
}

class ReadingCategoryPresenter {
  ReadingCategoryPresenter(this._view);

  final ReadingCategoryView _view;

  fetchCategory() async {
    final response = await http.get("https://gank.io/api/xiandu/categories");
    if (response.statusCode == 200) {
      _view.fetchCategoryReceived(ReadingCategoryResult.fromJson(response.body));
    } else {
      throw Exception('fetchCategory-Error ${response.statusCode}');
    }
  }

  fetchSites(String category) async {
    final response = await http.get("https://gank.io/api/xiandu/category/$category");
    if (response.statusCode == 200) {
      _view.fetchSitesReceived(ReadingSiteResult.fromJson(response.body));
    } else {
      throw Exception('fetchSites-$category-Error ${response.statusCode}');
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
