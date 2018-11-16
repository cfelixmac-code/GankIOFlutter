import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

// Web View Page
class WebViewPage extends StatefulWidget {
  WebViewPage(this.url);

  final String url;

  @override
  WebViewPageState createState() => WebViewPageState(url: url);
}

class WebViewPageState extends State<WebViewPage> {
  WebViewPageState({this.url});

  final _flutterWebviewPlugin = new FlutterWebviewPlugin();

  final String url;
  String _title = '加载中...';

  @override
  void initState() {
    super.initState();
    _registerPluginListener();
  }

  @override
  Widget build(BuildContext context) {
    Widget webView = WebviewScaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Row(
            children: <Widget>[
              Expanded(child: Text(_title)),
              IconButton(
                  icon: Icon(Icons.open_in_browser),
                  onPressed: () {
                    _launchURL();
                  }),
            ],
          ),
        ),
        url: url,
        withJavascript: true,
        withLocalStorage: true,
        withZoom: false,
        enableAppScheme: true,
        scrollBar: true);
    return webView;
  }

  _registerPluginListener() {
    // load finish listener
    _flutterWebviewPlugin.onStateChanged.listen((event) {
      if (event != null && event.type == WebViewState.finishLoad) {
        // nothing to do ... for now ...
      }
    });
    // title listener
    _flutterWebviewPlugin.onUrlChanged.listen((url) async {
      _title = await _flutterWebviewPlugin.evalJavascript("window.document.title");
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  // launch native browser
  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _flutterWebviewPlugin.dispose();
  }
}
