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
  late MyTableOptions? options;

  TableController? controller;
  late List<String>? headers;

  late MyTableType type;

  MyTable({
    super.key,
    required this.listTypeUrl,
    this.instanceUrl,
    this.pageSize = 10,
    this.page = 1,
    required this.name,
    this.options,
    this.enableDelete = false,
    this.enableEdit = false,
    this.headers,
    this.enableView = false,
    this.type = MyTableType.list,
  }) {
    controller = Get.put(
        TableController(
          listTypeUrl: listTypeUrl,
          page: page,
          headers: headers,
          pageSize: pageSize,
        ),
        tag: name);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextView(
                  display_message: '@count# @name# ',
                  data: {"name": name, "count": controller?.results.length}),
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
      ),
    );
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
    dprint("Options are");
    dprint(options);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: options?.physics,
        itemCount: controller?.results.value.length ?? 0,
        itemBuilder: (context, index) {
          var item = controller?.results.value[index];
          // dprint(options?.imageField);
          // dprint(item[options?.imageField]);
          return ListTile(
            leading: item[options?.imageField] != null
                ? Container(
                    width: 50,
                    height: 50,
                    child:
                        Image(image: NetworkImage(item[options?.imageField])))
                : options?.imageField != null
                    ? Container(
                        width: 50,
                        height: 50,
                      )
                    : TextView(
                        display_message: "",
                      ),
            title: TextView(
              display_message: options?.title ?? "Title (No set)",
              data: item,
            ),
            subtitle: TextView(
              display_message: options?.subtitle ?? "Sub Title (No set)",
              data: item,
            ),
            trailing: TextView(
              display_message: options?.trailing ?? "Trailing (No set)",
              data: item,
            ),
          );
        },
      ),
    );
  }
}
