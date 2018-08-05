import 'package:flutter/material.dart';
import 'package:gankio/data/reading_data.dart';

class ReadingCategoryPage extends StatefulWidget {
  @override
  _ReadingCategoryState createState() => _ReadingCategoryState();
}

class _ReadingCategoryState extends State<ReadingCategoryPage> {
  var _categories = List<ReadingCategory>();

  _ReadingCategoryState() {
    _categories.add(ReadingCategory(id: 'wow', name: '科技资讯'));
    _categories.add(ReadingCategory(id: 'apps', name: '趣味软件/游戏'));
    _categories.add(ReadingCategory(id: 'imrich', name: '装备党'));
    _categories.add(ReadingCategory(id: 'funny', name: '草根新闻'));
    _categories.add(ReadingCategory(id: 'android', name: 'Android'));
    _categories.add(ReadingCategory(id: 'diediedie', name: '创业新闻'));
    _categories.add(ReadingCategory(id: 'thinking', name: '独立思想'));
    _categories.add(ReadingCategory(id: 'iOS', name: 'iOS'));
    _categories.add(ReadingCategory(id: 'teamblog', name: '团队博客'));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _categoryWidgets = List<Widget>();
    for (var category in _categories) {
      _categoryWidgets.add(_buildCategoryItem(category));
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
            child: ListView(children: <Widget>[
              _buildSiteItem(),
              _buildSiteItem(),
              _buildSiteItem(),
              _buildSiteItem(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSiteItem() {
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
                    child: Image.network("http://ww1.sinaimg.cn/large/0066P23Wjw1f7efrjl9h0j3074074glz.jpg"),
                  ),
                  Expanded(
                    child: Text(
                      'Android Developer BlogBlogBlogBlogBlogBlogBlog',
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
}
