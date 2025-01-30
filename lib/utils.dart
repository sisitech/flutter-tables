import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';

updateFilterArgs(
    {required String value,
    TableController? controller,
    MyTableOptions? options}) async {
  String? fieldName = options?.searchField;
  // dprint("Value is $value");
  if (value.isEmpty) {
    var noKeys = controller?.searchArgs?.keys.toList();
    if (noKeys?.contains(options?.searchField) ?? false) {
      controller?.searchArgs.remove(options?.searchField);
    }
  } else {
    var noKeys = controller?.searchArgs?.keys;
    if (noKeys?.length == 0) {
      Map<String, dynamic> searchArgs = {};
      searchArgs[options?.searchField ?? ""] = value;
      // dprint(searchArgs);
      controller?.searchArgs = searchArgs;
    } else {
      controller?.searchArgs[options?.searchField ?? ""] = value;
    }
  }
  controller?.page = 1;
  await controller?.getData(isLoadMore: false);
}
