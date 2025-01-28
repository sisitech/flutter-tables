library flutter_tables;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MyTableType { card, table, list, sliver }

class MyTableModel {}

class MyTableOptions {
  late String? title;
  late String? subtitle;
  late String? searchField;
  String? name;
  final double searchDebounceSeconds;
  MyTableOptions(
      {this.title,
      this.searchField,
      this.subtitle,
      this.name,
      this.searchDebounceSeconds = 0.4});
}

class ListViewOptions extends MyTableOptions {
  late String? imageField;

  late String? trailing;
  late ScrollPhysics? physics;
  late bool shrinkWrap;
  late EdgeInsetsGeometry itemPadding;
  late Widget? separator;
  late Function? trailingWidgetBuilder;
  late Axis scrollDirection;
  late double? horizontalScrollHeight;

  ListViewOptions(
      {this.imageField,
      super.subtitle,
      super.title,
      super.name,
      super.searchDebounceSeconds = 0.4,
      this.shrinkWrap = true,
      this.trailing,
      super.searchField,
      this.trailingWidgetBuilder,
      this.separator,
      this.scrollDirection = Axis.vertical,
      this.horizontalScrollHeight,
      this.itemPadding = const EdgeInsets.symmetric(vertical: 10),
      this.physics = const AlwaysScrollableScrollPhysics()});
}

class TableViewOptions extends MyTableOptions {}
