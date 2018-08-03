import 'package:flutter/material.dart';
import 'package:gankio/display/fuli.dart';
import 'package:gankio/display/history.dart';
import 'package:gankio/display/search.dart';
import 'package:gankio/display/today.dart';
import 'package:gankio/display/xiandu.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gank IO Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new HomePage(title: 'Gank IO'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  var _pageController = PageController(keepPage: true);

  void _updatePageIndex(int index) {
    setState(() {
      this._pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      // ignore: deprecated_member_use
      MaterialPageRoute.debugEnableFadingRoutes = true;
    } catch (e) {
      // nothing..
    }
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: new Text(widget.title),
            ),
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
              },
            )
          ],
        ),
      ),
      body: new PageView(
        onPageChanged: (int position) {
          _updatePageIndex(position);
        },
        children: <Widget>[
          new TodayPage(),
          new HistoryPage(),
          new XianduPage(),
          new FuliPage(),
        ],
        controller: _pageController,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("今日")),
          new BottomNavigationBarItem(icon: Icon(Icons.history), title: Text("历史")),
          new BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("闲读")),
          new BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("设置")),
        ],
        currentIndex: _pageIndex,
        onTap: (int pos) {
          _pageController.animateToPage(pos, duration: new Duration(milliseconds: 400), curve: Curves.easeInOut);
          _updatePageIndex(pos);
          print("position : $pos");
        },
      ),
    );
  }
}

class GankNavigator extends MaterialPageRoute {
  GankNavigator({@required WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}
