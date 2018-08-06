import 'package:flutter/material.dart';
import 'package:gankio/data/reading_data.dart';
import 'package:gankio/presenter/reading_presenter.dart';
import 'package:event_bus/event_bus.dart';

var _bus = EventBus();

class ReadingCategoryPage extends StatefulWidget {
  @override
  _ReadingCategoryState createState() => _ReadingCategoryState();
}

class _ReadingCategoryState extends State<ReadingCategoryPage> implements ReadingCategoryView {
  var _categories = List<ReadingCategory>();
  var _sites = List<ReadingSite>();

  ReadingCategoryPresenter _presenter;

  _ReadingCategoryState() {
    _presenter = ReadingCategoryPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.fetchCategory();
    _bus.on<ReadingCategoryEvent>().listen((event) {
      if (this.mounted) {
        setState(() {
          _categories.clear();
          _categories.addAll(event.categories);
          _presenter.fetchSites(event.categories[0].enName);
        });
      }
    });
    _bus.on<ReadingSiteEvent>().listen((event) {
      if (this.mounted) {
        setState(() {
          _sites.clear();
          _sites.addAll(event.sites);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _categoryWidgets = List<Widget>();
    for (var category in _categories) {
      _categoryWidgets.add(_buildCategoryItem(category));
    }

    var _siteWidgets = List<Widget>();
    for (var site in _sites) {
      _siteWidgets.add(_buildSiteItem(site));
    }

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: new Text('选择闲读分类'),
            ),
          ],
        ),
      ),
      body: Row(
        children: <Widget>[
          Container(
            color: Color(0x99D9DAE4),
            padding: EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width * 0.3,
            child: ListView(
              children: _categoryWidgets,
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width * 0.7,
            child: ListView(children: _siteWidgets),
          ),
        ],
      ),
    );
  }

  Widget _buildSiteItem(ReadingSite site) {
    return Material(
      child: InkWell(
        onTap: () {
          // ------------
        },
        child: Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          margin: EdgeInsets.only(bottom: 18.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 40.0,
                    margin: EdgeInsets.only(right: 10.0),
                    child: Image.network(site.icon),
                  ),
                  Expanded(
                    child: Text(
                      site.title,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                height: 1.2,
                margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                color: Colors.black12,
              )
            ],
          ),
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget _buildCategoryItem(ReadingCategory category) {
    return Container(
      height: 46.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Center(
          child: Text(
            '${category.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  fetchCategoryReceived(ReadingCategoryResult result) {
    if (result.results != null && result.results.length != 0) {
      _bus.fire(ReadingCategoryEvent(categories: result.results));
    }
  }

  @override
  fetchSitesReceived(ReadingSiteResult result) {
    if (result.results != null && result.results.length != 0) {
      _bus.fire(ReadingSiteEvent(sites: result.results));
    }
  }
}
