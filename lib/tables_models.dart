import 'package:flutter/material.dart';

enum MyTableType { card, table, list }

class MyTableModel {}

class MyTableOptions {}

class ListViewOptions extends MyTableOptions {
  late String? imageField;
  late String? title;
  late String? subtitle;
  late String? trailing;
  late ScrollPhysics? physics;
  late EdgeInsetsGeometry itemPadding;
  late Widget? separator;
  ListViewOptions(
      {this.imageField,
      this.subtitle,
      this.title,
      this.trailing,
      this.separator,
      this.itemPadding = const EdgeInsets.symmetric(vertical: 10),
      this.physics = const AlwaysScrollableScrollPhysics()});
}

class TableViewOptions extends MyTableOptions {}
