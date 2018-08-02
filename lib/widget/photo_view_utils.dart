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
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:gankio/widget/photo_view_scale_type.dart';

PhotoViewScaleType nextScaleType(PhotoViewScaleType actual) {
  switch (actual) {
    case PhotoViewScaleType.contained:
      return PhotoViewScaleType.covering;
    case PhotoViewScaleType.covering:
      return PhotoViewScaleType.originalSize;
    case PhotoViewScaleType.originalSize:
      return PhotoViewScaleType.contained;
    case PhotoViewScaleType.zooming:
      return PhotoViewScaleType.contained;
    default:
      return PhotoViewScaleType.contained;
  }
}

double getScaleForScaleType(
    {@required Size size, @required PhotoViewScaleType scaleType, @required ImageInfo imageInfo}) {
  switch (scaleType) {
    case PhotoViewScaleType.contained:
      return scaleForContained(size: size, imageInfo: imageInfo);
    case PhotoViewScaleType.covering:
      return scaleForCovering(size: size, imageInfo: imageInfo);
    case PhotoViewScaleType.originalSize:
      return 1.0;
    default:
      return null;
  }
}

double scaleForContained({@required Size size, @required ImageInfo imageInfo}) {
  final int imageWidth = imageInfo.image.width;
  final int imageHeight = imageInfo.image.height;

  final double screenWidth = size.width;
  final double screenHeight = size.height;

  return Math.min(screenWidth / imageWidth, screenHeight / imageHeight);
}

double scaleForCovering({@required Size size, @required ImageInfo imageInfo}) {
  final int imageWidth = imageInfo.image.width;
  final int imageHeight = imageInfo.image.height;

  final double screenWidth = size.width;
  final double screenHeight = size.height;

  return Math.max(screenWidth / imageWidth, screenHeight / imageHeight);
}
