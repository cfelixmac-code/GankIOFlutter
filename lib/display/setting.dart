import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
            height: 75.0,
            width: 75.0,
            child: Image.asset('images/gankio.png'),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'Gank.IO Flutter',
                    style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600)),
                TextSpan(text: '\nby cfelixmac_v1.0_201808', style: TextStyle(color: Colors.black54, fontSize: 12.0)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 80.0),
            child: Column(
              children: <Widget>[
                Text(
                  '3rd Libraries:',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black45, fontSize: 13.0),
                ),
                Text('flutter_webview_plugin',
                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontSize: 12.0)),
                Text('event_bus',
                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontSize: 12.0)),
                Text('fluttertoast',
                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45, fontSize: 12.0)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
