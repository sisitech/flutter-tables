library flutter_tables;

import 'package:flutter/material.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_tables/text_view.dart';
import 'package:get/get.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class MyTable extends StatelessWidget {
  late String listTypeUrl;
  late String name;
  late String? instanceUrl;
  int pageSize;
  late bool enableDelete;
  late bool enableEdit;
  late bool enableView;
  late int page;
  late Function? onSelect;

  String deleteMessageTemplate;

  Map<String, dynamic> args;

  late MyTableOptions? options;

  late Function? transformRow;

  TableController? controller;
  late List<String>? headers;

  late MyTableType type;
  Function? updateWidget;

  Function? preUpdate;

  Function? onControllerSetup;

  late Widget? bottomSheet;

  MyTable(
      {super.key,
      this.enableDelete = false,
      this.enableEdit = false,
      required this.listTypeUrl,
      this.instanceUrl,
      this.pageSize = 10,
      this.page = 1,
      required this.name,
      this.options,
      this.preUpdate,
      this.headers,
      this.onControllerSetup,
      this.deleteMessageTemplate = "Delete id @id#",
      this.updateWidget,
      this.args = const {},
      this.transformRow,
      this.onSelect,
      this.bottomSheet,
      this.enableView = false,
      this.type = MyTableType.list,
      TableController? tableController}) {
    dprint("Adding the controller");
    controller = Get.put(
        TableController(
            listTypeUrl: listTypeUrl,
            instanceUrl: instanceUrl,
            page: page,
            headers: headers,
            preUpdate: preUpdate,
            pageSize: pageSize,
            bottomSheet: bottomSheet,
            onControllerSetup: onControllerSetup,
            deleteMessageTemplate: deleteMessageTemplate,
            enableDelete: enableDelete,
            enableEdit: enableEdit,
            updateWidget: updateWidget,
            options: options,
            onSelect: onSelect,
            transformRow: transformRow,
            args: args),
        tag: name);

    if (onControllerSetup != null) {
      onControllerSetup!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // dprint("Revuilding with acunt");
      // dprint(controller?.count);

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onDoubleTap: () async {
                await controller!.getData();
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextView(
                  display_message: "${controller?.count} ${name} ",
                  style: Get.theme.textTheme.headline6,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: controller!.isLoading.value
                ? CircularProgressIndicator()
                : MyTableViewSelector(
                    controller: controller,
                    type: type,
                    options: options,
                  ),
          ),
        ],
      );
    });
  }
}

// Switch between card,lists and tables
class MyTableViewSelector extends StatelessWidget {
  TableController? controller;
  late MyTableOptions? options;

  late MyTableType type;

  MyTableViewSelector({
    super.key,
    this.controller,
    this.options,
    this.type = MyTableType.list,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MyTableType.list:
        return MyTableListView(
          controller: controller,
          options: options != null ? options as ListViewOptions : null,
        );
        break;
      case MyTableType.table:
        return MyTableTableView(
          controller: controller,
        );
        break;
      default:
        return MyTableListView(
          controller: controller,
        );
    }
  }
}

class MyTableTableView extends StatelessWidget {
  TableController? controller;

  MyTableTableView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx((() => Table(
          children: [
            TableRow(children: [
              ...controller?.visibleHeaders.value
                      .map((header) => Column(children: [
                            TextView(
                              display_message: "${header["name"]}",
                              data: header,
                            )
                          ])) ??
                  []
            ]),
            ...controller?.results
                    .map(
                      (element) => TableRow(children: [
                        ...controller?.visibleHeaders.value
                                .map((header) => Column(children: [
                                      TextView(
                                        display_message: "@${header["field"]}#",
                                        data: element,
                                      )
                                    ])) ??
                            []
                      ]),
                    )
                    .toList() ??
                []
          ],
        )));
  }
}

class MyTableListView extends StatelessWidget {
  TableController? controller;
  late ListViewOptions? options;

  MyTableListView({
    super.key,
    this.controller,
    this.options,
  }) {
    // dprint("Options are");
    // dprint(options);
  }

  @override
  Widget build(BuildContext context) {
    const defaultSeparator = SizedBox(
      width: 0,
      height: 0,
    );
    return Obx(
      () => ListView.separated(
        separatorBuilder: (context, index) {
          if (options!.separator != null) {
            return options?.separator ?? defaultSeparator;
          }
          return defaultSeparator;
        },
        shrinkWrap: options?.shrinkWrap ?? true,
        physics: options?.physics,
        itemCount: controller?.results.value.length ?? 0,
        itemBuilder: (context, index) {
          var item = controller?.results.value[index];
          // dprint(options?.imageField);
          // dprint(item[options?.imageField]);
          return GestureDetector(
            onTap: () {
              // controller
              if (controller!.onSelect != null) {
                controller!.selectItem(item);
              } else {
                controller!.showBottomSheet(item);
              }
            },
            child: Padding(
              padding: options!.itemPadding,
              child: ListTile(
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
                  display_message: options?.title ?? "Title (No set)",
                  data: item,
                ),
                subtitle: TextView(
                  display_message: options?.subtitle ?? "Sub Title (No set)",
                  data: item,
                ),
                trailing: getTrailing(context, controller, options, item),
              ),
            ),
          );
        },
      ),
    );
  }

  getTrailing(BuildContext context, TableController? controller,
      ListViewOptions? options, Map<String, dynamic> item) {
    if (options != null && options.trailingWidgetBuilder != null) {
      final func = this.options?.trailingWidgetBuilder;
      return func!(context, controller, options, item);
    } else {
      return defaultTrailingWIdget(context, controller, options, item);
    }
  }

  defaultTrailingWIdget(context, TableController? controller, options, item) {
    // dprint(controller?.enableDelete);
    // dprint(controller?.enableEdit);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (controller?.enableDelete ?? false)
          OutlinedButton(
            onPressed: () async {
              var res = await controller?.deleteItem(item);
            },
            child: Icon(
              Icons.delete,
              color: Get.theme.errorColor,
            ),
          ),
        if (controller?.enableEdit ?? false)
          const SizedBox(
            width: 5,
          ),
        if (controller?.enableEdit ?? false)
          OutlinedButton(
            onPressed: () async {
              if (controller?.updateWidget != null) {
                final widget = controller?.updateWidget;
                var newItem = item;
                if (controller?.preUpdate != null) {
                  final preUp = controller?.preUpdate;
                  newItem = preUp!(item);
                  dprint("Got ther following preups");
                } else {
                  dprint("No pre update function found");
                }
                dprint("The new Value is ");
                dprint(newItem);
                var res = await Get.to(widget!(), arguments: {"item": newItem});
                dprint("Got the value");
                dprint(res);
              } else {
                dprint("updateWidget not set for edit");
              }
            },
            child: Icon(
              Icons.edit,
              color: Get.theme.colorScheme.secondary,
            ),
          ),
      ],
    );
  }
}
