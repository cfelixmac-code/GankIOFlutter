/*
 * Copyright 2018 Renan C. Araújo
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"),  * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish,  * distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,  * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
 * USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
library photo_view;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gankio/widget/photo_view_image_wrapper.dart';
import 'package:gankio/widget/photo_view_scale_type.dart';
import 'package:gankio/widget/photo_view_utils.dart';

class PhotoView extends StatefulWidget {
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Color backgroundColor;
  final double minScale;
  final double maxScale;

  PhotoView({
    Key key,
    @required this.imageProvider,
    this.loadingChild,
    this.backgroundColor = const Color.fromRGBO(0, 0, 0, 1.0),
    this.minScale = 0.0,
    this.maxScale,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _PhotoViewState();
  }
}

class _PhotoViewState extends State<PhotoView> {
  PhotoViewScaleType _scaleType;

  Future<ImageInfo> _getImage() {
    Completer completer = new Completer<ImageInfo>();
    ImageStream stream = widget.imageProvider.resolve(new ImageConfiguration());
    stream.addListener((ImageInfo info, bool completed) {
      completer.complete(info);
    });
    return completer.future;
  }

  void onDoubleTap() {
    setState(() {
      _scaleType = nextScaleType(_scaleType);
    });
  }

  void onStartPanning() {
    setState(() {
      _scaleType = PhotoViewScaleType.zooming;
    });
  }

  @override
  void initState() {
    super.initState();
    _scaleType = PhotoViewScaleType.contained;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: _getImage(),
        builder: (BuildContext context, AsyncSnapshot<ImageInfo> info) {
          if (info.hasData) {
            return new PhotoViewImageWrapper(
              onDoubleTap: onDoubleTap,
              onStartPanning: onStartPanning,
              imageInfo: info.data,
              scaleType: _scaleType,
              backgroundColor: widget.backgroundColor,
              minScale: widget.minScale,
              maxScale: widget.maxScale,
            );
          } else {
            return buildLoading();
          }
        });
  }

  Widget buildLoading() {
    return widget.loadingChild != null
        ? widget.loadingChild
        : new Center(
            child: new Text(
            "Loading",
            style: new TextStyle(color: Colors.white),
          ));
  }
}
