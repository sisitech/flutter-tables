import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';

const successStatusCodes = [200, 201, 204];

class TableController extends GetxController {
  late String listTypeUrl;
  late String? instanceUrl;
  int pageSize;
  late bool enableDelete;
  late bool enableEdit;
  late bool enableView;
  late Function? transformRow;

  int page;
  late List<String>? headers;
  Map<String, dynamic> args;

  var authProv = Get.find<AuthProvider>();

  var visibleHeaders = [].obs;

  TableController({
    required this.listTypeUrl,
    this.instanceUrl,
    this.pageSize = 10,
    this.page = 1,
    this.enableDelete = false,
    this.headers,
    this.enableEdit = false,
    this.transformRow,
    this.args = const {},
    this.enableView = false,
  });

  var results = [].obs;
  var isLoading = false.obs;
  var count = 0.obs;

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

  getData() async {
    try {
      isLoading.value = true;
      results.value = [];
      visibleHeaders.value = [];
      dprint("Getting. dara");
      dprint(getQueryParams());
      var res = await authProv.formGet(listTypeUrl, query: getQueryParams());
      isLoading.value = false;
      dprint(res.statusCode);
      dprint(res.body);
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
          dprint(visibleHeaders);

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
