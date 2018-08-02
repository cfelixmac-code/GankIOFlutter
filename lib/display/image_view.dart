import 'package:flutter/material.dart';
import 'package:gankio/widget/photo_view.dart';

class ImageViewPage extends StatelessWidget {
  ImageViewPage(this.imageUrl);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: new Text('查看大图'),
            ),
          ],
        ),
      ),
      body: new Container(
        child: new PhotoView(
          imageProvider: new NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
