import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_tables/tables_connect.dart';
import 'package:flutter_tables/text_view.dart';
import 'package:get/get.dart';
import 'package:flutter_form/utils.dart';
import 'tables_models.dart';

const successStatusCodes = [200, 201, 204];

class TableController extends GetxController {
  late String listTypeUrl;
  late String? instanceUrl;
  int pageSize;
  late bool enableDelete;
  late bool enableEdit;
  late bool enableView;
  late Function? transformRow;
  late MyTableOptions? options;

  Function? updateWidget;

  late Function? onSelect;

  late dynamic? selectedItem;
  String deleteMessageTemplate;

  int page;
  late List<String>? headers;
  Map<String, dynamic> args;

  var tableProv = Get.put<TableProvider>(TableProvider());

  var visibleHeaders = [].obs;

  var isDeleting = false.obs;

  TableController({
    required this.listTypeUrl,
    this.instanceUrl,
    this.pageSize = 10,
    required this.deleteMessageTemplate,
    this.page = 1,
    this.enableDelete = false,
    this.headers,
    this.enableEdit = false,
    this.transformRow,
    this.updateWidget,
    this.args = const {},
    this.selectedItem,
    this.onSelect,
    this.options,
    this.enableView = false,
  });

  var results = [].obs;
  var isLoading = false.obs;
  var count = 0.obs;

  var deleteErrorMEssage = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dprint("Table controller ");
    getData();
  }

  toTileCase(String s) {
    var res = s.replaceAll("_", " ");
    return res.split(" ").map((e) => e.capitalizeFirst).join(" ");
  }

  Map<String, dynamic> getQueryParams() {
    dprint("Getting para,");
    return {"page_size": "${pageSize}", "page": "${page}", ...args};
  }

  selectItem(Map<String, dynamic> item) {
    if (item.containsKey("id")) {
      this.selectedItem = item;
      if (onSelect != null) {
        onSelect!(options, item);
      }
    }
  }

  getHeaders(Map<String, dynamic> row) {
    dprint(row);
    if (headers != null) {
      return headers
          ?.map((key) => {"name": toTileCase(key), "field": key})
          .toList();
    }
    // dprint(row);
    var tableHeaders = [];
    try {
      row.forEach((key, value) {
        tableHeaders.add({"name": toTileCase(key), "field": key});
      });
      dprint(tableHeaders);
      return tableHeaders;
    } catch (e) {
      dprint("Failed parsing table headers");
      dprint(e);
      return [];
    }
  }

  getInstanceUrl() {
    if (instanceUrl != null) {
      return this.instanceUrl?.toUrlNoSlash();
    }
    return this.listTypeUrl?.toUrlNoSlash();
  }

  deleteItem(Map<String, dynamic> item) async {
    deleteErrorMEssage.value = "";

    var res = await Get.defaultDialog(
      title: "Delete ?",
      content: Obx(() {
        return Column(
          children: [
            TextView(
              display_message: deleteMessageTemplate,
              data: item,
            ),
            if (deleteErrorMEssage.value != "")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${deleteErrorMEssage.value}",
                  style: TextStyle(color: Get.theme.errorColor),
                ),
              ),
          ],
        );
      }),
      actions: [
        Obx(() {
          return TextButton(
            onPressed: isDeleting.value
                ? null
                : () {
                    dprint("Canel");
                    Get.back();
                  },
            child: Text(
              "Cancel",
            ),
          );
        }),
        Obx(() {
          return ElevatedButton(
            onPressed: isDeleting.value
                ? null
                : () async {
                    dprint("OK");
                    try {
                      isDeleting.value = true;
                      deleteErrorMEssage.value = "";
                      var delRes = await tableProv.tablesDelete(
                          getInstanceUrl(), item["id"]);
                      dprint(delRes.statusCode);
                      if (delRes.statusCode == 204) {
                        Get.back(result: item);
                      } else if (delRes.statusCode == 404) {
                        dprint("not found");
                        deleteErrorMEssage.value = "Item not found";
                      }
                    } catch (e) {
                      isDeleting.value = false;
                      dprint(e);
                      return;
                    }
                    isDeleting.value = false;
                  },
            child: Text(
              isDeleting.value ? "Deleting..." : "Delete",
            ),
          );
        }),
      ],
    );
    dprint(res);

    return res;
  }

  getData() async {
    try {
      isLoading.value = true;
      results.value = [];
      visibleHeaders.value = [];
      dprint("Getting. dara");
      dprint(getQueryParams());
      dprint(listTypeUrl);
      var res = await tableProv.formGet(listTypeUrl, query: getQueryParams());
      isLoading.value = false;
      dprint(res.statusCode);
      // dprint(res.body);
      if (successStatusCodes.contains(res.statusCode)) {
        dprint("Status Code success");
        var all = [];
        if (res.body.containsKey("results")) {
          all = res.body["results"] ?? [];
          count.value = res.body["count"];
        } else {
          all = res.body ?? [];
          count.value = all.length;
        }
        if (all.length > 0) {
          visibleHeaders.value = getHeaders(all[0]);
          // dprint(visibleHeaders);

          results.value = all.map((e) {
            if (transformRow != null) {
              return transformRow!(e);
            }
            return e;
          }).toList();
        }
      } else {}
      return true;
    } catch (e) {
      isLoading.value = false;
      dprint("Failedd");
      dprint(e);
      return false;
    }
  }
}
