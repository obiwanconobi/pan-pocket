import 'package:flutter/material.dart';

class ScreenHelper{


  screenWidthMoreThanHeight(BuildContext context) {
    double width = MediaQuery
        .sizeOf(context)
        .width;
    double height = MediaQuery
        .sizeOf(context)
        .height;

    if (width > height) {
      return true;
    }

    return false;
  }

}