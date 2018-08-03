import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewer extends StatelessWidget {
  WebViewer({this.url, this.title = "Gank IO"});

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        withJavascript: true,
        withLocalStorage: true,
        withZoom: false,
        enableAppScheme: true,
        url: url);
  }
}
