library flutter_tables;

import 'package:flutter/material.dart';

enum MyTableType { card, table, list }

class MyTableModel {}

class MyTableOptions {
  late String? title;
  late String? subtitle;
}

class ListViewOptions extends MyTableOptions {
  late String? imageField;
  late String? title;
  late String? subtitle;
  late String? trailing;
  late ScrollPhysics? physics;
  late bool shrinkWrap;
  late EdgeInsetsGeometry itemPadding;
  late Widget? separator;
  late Function? trailingWidgetBuilder;

  ListViewOptions(
      {this.imageField,
      this.subtitle,
      this.title,
      this.shrinkWrap = true,
      this.trailing,
      this.trailingWidgetBuilder,
      this.separator,
      this.itemPadding = const EdgeInsets.symmetric(vertical: 10),
      this.physics = const AlwaysScrollableScrollPhysics()});
}

class TableViewOptions extends MyTableOptions {}
