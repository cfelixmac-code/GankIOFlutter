import 'package:flutter/material.dart';
import 'package:gankio/display/fuli.dart';
import 'package:gankio/display/ganhuo.dart';
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new PageView(
        children: <Widget>[
          new TodayPage(),
          new GanhuoPage(),
          new XianduPage(),
          new FuliPage(),
        ],
        controller: _pageController,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Today")),
          new BottomNavigationBarItem(icon: Icon(Icons.history), title: Text("History")),
          new BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("XianDu")),
          new BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), title: Text("FuLi")),
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
