import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetDataController extends GetxController {
  Size getSize(GlobalKey key) {
    final RenderBox renderBox = key.currentContext.findRenderObject();

    if(renderBox != null) {
      return renderBox.size;
    } else {
      return Size.zero;
    }
  }
}