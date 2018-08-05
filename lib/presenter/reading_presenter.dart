import 'package:http/http.dart' as http;

abstract class ReadingCategoryView {
  fetchCategoryReceived();

  fetchSitesReceived();
}

class ReadingCategoryPresenter {
  ReadingCategoryPresenter(this._view);

  final ReadingCategoryView _view;

  fetchCategory() async {
    final response = await http.get("https://gank.io/api/xiandu/categories");
    if (response.statusCode == 200) {
      _view.fetchCategoryReceived();
    } else {
      throw Exception('fetchCategory-Error ${response.statusCode}');
    }
  }

  fetchSites(String category) async {
    final response = await http.get("https://gank.io/api/xiandu/category/$category");
    if (response.statusCode == 200) {
      _view.fetchSitesReceived();
    } else {
      throw Exception('fetchSites-$category-Error ${response.statusCode}');
    }
  }
}
