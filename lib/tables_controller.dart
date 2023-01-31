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
  Function? preUpdate;

  late Widget? bottomSheet;

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
  Function? onControllerSetup;

  TableController({
    required this.listTypeUrl,
    this.instanceUrl,
    this.pageSize = 10,
    required this.deleteMessageTemplate,
    this.page = 1,
    this.onControllerSetup,
    this.enableDelete = false,
    this.headers,
    this.enableEdit = false,
    this.transformRow,
    this.updateWidget,
    this.args = const {},
    this.selectedItem,
    this.preUpdate,
    this.bottomSheet,
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
    // dprint("Table controller ");
    getData();
  }

  toTileCase(String s) {
    var res = s.replaceAll("_", " ");
    return res.split(" ").map((e) => e.capitalizeFirst).join(" ");
  }

  Map<String, dynamic> getQueryParams() {
    // dprint("Getting para,");
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
      // dprint(tableHeaders);
      return tableHeaders;
    } catch (e) {
      dprint("Failed parsing table headers");
      dprint(e);
      return [];
    }
  }

  getInstanceUrl() {
    if (instanceUrl != null) {
      return instanceUrl?.toUrlNoSlash();
    }
    return listTypeUrl?.toUrlNoSlash();
  }

  updateAddItem(Map<String, dynamic> item, {String field = "id"}) {
    var resultsTemp = results.value.toList();
    if (resultsTemp.contains((element) => element?[field] == item?[field])) {
      // Element found;
      // dprint("Element found");
      var index =
          resultsTemp.indexWhere((element) => element[field] == item[field]);
      // dprint(index);
    } else {
      // Element not founc
      // dprint("Element not found");
      resultsTemp.insert(0, item);
      results.value = resultsTemp; // results.value;
      count.value = count.value + 1;
      // dprint("Count $count");
    }
  }

  showBottomSheet(Map<String, dynamic> item) async {
    var bottomSheetWidget = bottomSheet ??
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextView(
                  display_message: options?.title ?? "Title",
                  data: item,
                  style: Get.theme.textTheme.headline5,
                  maxLines: 2,
                ),
              ),
              Divider(),
              ...getBottomSheetDetaislTextViews(
                  item: item, title: options?.subtitle ?? "Sub Title"),
            ],
          ),
        );
    Get.bottomSheet(bottomSheetWidget);
  }

  getBottomSheetDetaislTextViews(
      {required Map<String, dynamic> item, required String title}) {
    return title
        .split("\n")
        .map(
          (message) => Padding(
            padding: const EdgeInsets.all(10),
            child: TextView(
              display_message: message,
              data: item,
              maxLines: 30,
            ),
          ),
        )
        .toList();
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
                    // dprint("Canel");
                    Get.back();
                  },
            child: Text(
              "Cancel",
              style: isDeleting.value
                  ? null
                  : TextStyle(color: Get.theme.errorColor),
            ),
          );
        }),
        Obx(() {
          return ElevatedButton(
            onPressed: isDeleting.value
                ? null
                : () async {
                    // dprint("OK");
                    try {
                      isDeleting.value = true;
                      deleteErrorMEssage.value = "";
                      var delRes = await tableProv.tablesDelete(
                          getInstanceUrl(), item["id"]);
                      dprint(delRes.statusCode);
                      if (delRes.statusCode == 204) {
                        dprint("Deleted !!!!");
                        // dprint(
                        //     "COunt at ${results.value.length} ${count.value}");
                        results.value = results.value
                            .where((element) => element["id"] != item["id"])
                            .toList();
                        count.value = count.value - 1;
                        // dprint(
                        //     "Count After ${results.value.length} ${count.value}");

                        Get.back(result: item);
                      } else if (delRes.statusCode == 404) {
                        // dprint("not found");
                        deleteErrorMEssage.value = "Item not found";
                      } else if (delRes.statusCode == 500) {
                        deleteErrorMEssage.value = "Failed, Contact Admin.";
                      } else {
                        dprint(delRes.body);
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

  resetFetchOpttions() {
    isLoading.value = true;
    results.value = [];
    visibleHeaders.value = [];
    count.value = 0;
  }

  getData() async {
    try {
      resetFetchOpttions();
      dprint("Getting. dara");
      dprint(getQueryParams());
      dprint(listTypeUrl);
      var res = await tableProv.formGet(listTypeUrl, query: getQueryParams());
      isLoading.value = false;
      dprint(res.statusCode);
      // dprint(res.body);
      if (successStatusCodes.contains(res.statusCode)) {
        // dprint("Status Code success");
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
