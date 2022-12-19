library flutter_tables;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTableSliverTabbedView extends StatelessWidget {
  final double? expandedHeight;
  final FlexibleSpaceBar flexibleSpace;
  final List<Tab> tabs;
  final List<Widget> tabsViewChildren;
  final Widget title;
  final bool sliverBarFloating;
  final bool sliverBarPinned;

  final bool tabBarFloating;
  final bool tabBarPinned;

  const MyTableSliverTabbedView({
    super.key,
    this.expandedHeight,
    required this.flexibleSpace,
    required this.tabs,
    this.sliverBarFloating = false,
    this.sliverBarPinned = false,
    this.tabBarFloating = true,
    this.tabBarPinned = false,
    required this.tabsViewChildren,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: sliverBarFloating,
              pinned: sliverBarPinned,
              flexibleSpace: flexibleSpace,
              expandedHeight: expandedHeight,
              title: title,
              forceElevated: innerBoxIsScrolled,
              // centerTitle: true,

              // bottom: TabBar(tabs: tabs),
            ),
            SliverPersistentHeader(
                floating: tabBarFloating,
                pinned: tabBarPinned,
                delegate: TabPersistentHeader(
                  tabs: tabs,
                ))
          ];
        },
        body: TabBarView(
          children: tabsViewChildren,
        ),
      ),
    );
  }
}

class TabPersistentHeader extends SliverPersistentHeaderDelegate {
  late final double? expandedHeight;
  final List<Tab> tabs;

  TabPersistentHeader({required this.tabs, this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Card(
      child: TabBar(
        tabs: tabs,
      ),
    );
  }

  var minHeight = kToolbarHeight + 30;
  @override
  // TODO: implement maxExtent
  double get maxExtent => expandedHeight ?? minHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
