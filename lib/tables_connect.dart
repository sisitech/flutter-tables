library flutter_tables;

import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

class TableProvider extends AuthProvider {
  APIConfig? config;
  TableProvider() {
    config = Get.find<APIConfig>();
    // dprint(config.toString());
  }

  Future<Response> tablesDelete(String? path, int id,
      {contentType = "application/json"}) {
    var url = "${config!.apiEndpoint}/${path}/${id}/";
    dprint(url);
    return delete(url, contentType: contentType);
  }
}
