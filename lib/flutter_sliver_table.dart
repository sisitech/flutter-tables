import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';

import 'tables_controller.dart';
import 'tables_models.dart';

class SliverListView extends StatelessWidget {
  final TableController? controller;
  final ListViewOptions? options;
  final Widget? noDataWidget;
  final Function(BuildContext context, dynamic item, ListViewOptions? options)?
      itemBuilder;

  const SliverListView({
    super.key,
    this.controller,
    this.options,
    this.itemBuilder,
    this.noDataWidget,
  });
  @override
  Widget build(BuildContext context) {
    const defaultSeparator = SizedBox(
      width: 0,
      height: 0,
    );

    return Obx(
      () {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (controller?.isLoading.value ?? false) {
              return const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller?.results.isEmpty ?? true) {
              return SizedBox(
                height: 50,
                width: 50,
                child: Center(child: noDataWidget ?? Text("No data".ctr)),
              );
            }
            if (controller?.results.isEmpty ?? true) {
              return null;
            }
            // Ensure it doesn't go past lengt+1
            if (controller?.results.length == index) {
              return null;
            }
            var item = controller?.results.value[index];
            if (itemBuilder != null) {
              return itemBuilder!(context, item, options);
            }
            return ListTile(
              leading: item[options?.imageField] != null
                  ? Container(
                      width: 50,
                      height: 50,
                      child: Hero(
                        tag: "image${item['id']}",
                        child: Image(
                            image: NetworkImage(item[options?.imageField])),
                      ))
                  : options?.imageField != null
                      ? Container(
                          width: 50,
                          height: 50,
                        )
                      : null,
              title: TextView(
                display_message: (options?.title ?? "Title (No set)").tr,
                data: item,
              ),
              subtitle: TextView(
                display_message: (options?.subtitle ?? "Sub Title (No set)").tr,
                data: item,
              ),
              // trailing: getTrailing(context, controller, options, item),
            );
          }, childCount: (controller?.results.value.length ?? 0) + 1),
        );
      },
    );
  }
}
