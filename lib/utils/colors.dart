import 'dart:ui';

import 'package:flutter/material.dart';

class ColorHelper{
  static var colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.grey,
    Colors.black,
    Colors.white
  ];

  static var theme_color = Colors.white;
  static var text_color = Colors.grey[500];
  static var grey_100 = Colors.grey[100];

  static var pnl_chart_color = Color(0xff232d3b).withOpacity(0.5);
  static var pnl_chart_box_shadow = Colors.black.withOpacity(0.1);
  static var pnl_chart_fill_line_color = Color(0xff37434d);
  static var pnl_fill_tiles_data = Color(0xff68737d);
  static List<Color> pnl_gradient_color = [Color(0xff23b6e6), Color(0xff02d39a)];
  static List<Color> pnl_second_gradient_color = [Color(0xff23b6e6).withOpacity(0.3), const Color(0xff02d39a).withOpacity(0.3)];

}