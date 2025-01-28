import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';

updateFilterArgs(
    {required String value,
    TableController? controller,
    MyTableOptions? options}) async {
  String? fieldName = options?.searchField;
  dprint("Value is $value");
  if (value.isEmpty) {
    var noKeys = controller?.args?.keys.toList();
    if (noKeys?.contains(options?.searchField) ?? false) {
      controller?.args.remove(options?.searchField);
    }
  } else {
    var noKeys = controller?.args?.keys;
    if (noKeys?.length == 0) {
      Map<String, dynamic> searchArgs = {};
      searchArgs[options?.searchField ?? ""] = value;
      dprint(searchArgs);
      controller?.args = searchArgs;
    } else {
      controller?.args[options?.searchField ?? ""] = value;
    }
  }
  await controller?.getData(isLoadMore: false);
}
