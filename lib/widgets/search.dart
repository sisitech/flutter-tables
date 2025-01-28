import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/options.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';

import '../tables_models.dart';

class SearchDebouncer {
  final int milliseconds;
  Timer? _timer;

  SearchDebouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      action();
      _timer = null; // Cleanup after execution
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isRunning => _timer?.isActive ?? false;
}

class SearchBarController extends GetxController {
  double debounceSeconds;
  late final SearchDebouncer debouncer;
  final TextEditingController controller = TextEditingController();
  var hasText = false.obs;

  SearchBarController({this.debounceSeconds = 0.4});
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    debouncer = SearchDebouncer(milliseconds: (debounceSeconds * 1000).toInt());
  }

  clear() {
    controller.clear();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    debouncer.cancel();
    controller.dispose();
    super.onClose();
  }
}

class MyTableSearch extends StatelessWidget {
  final Function(String value)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;

  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final MyTableOptions? options;

  MyTableSearch({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.options,
    this.onTap,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    var searchController = Get.find<SearchBarController>(tag: options?.name);
    return SearchBar(
      controller: searchController.controller,
      padding: WidgetStatePropertyAll(
          EdgeInsetsDirectional.symmetric(horizontal: 16)),
      leading: Icon(Icons.search),
      trailing: [
        Obx(() {
          return Column(children: [
            if (searchController.hasText.value)
              IconButton(
                  onPressed: !searchController.hasText.value
                      ? null
                      : () {
                          searchController.controller.clear();
                          searchController.hasText.value = false;
                          if (onChanged != null) {
                            searchController.debouncer.run(() {
                              onChanged!("");
                            });
                          }
                        },
                  icon: Icon(
                    Icons.close,
                  )),
          ]);
        })
      ],
      onChanged: (value) {
        if (onChanged != null) {
          searchController.debouncer.run(() {
            onChanged!(value);
          });
        }
        searchController.hasText.value = value.isNotEmpty;
      },
      onSubmitted: onSubmitted,
      onTap: onTap,
      hintText: 'Search...',
      onTapOutside: (PointerDownEvent event) {
        FocusScope.of(context).unfocus();
        if (onTapOutside != null) {
          onTapOutside!(event);
        }
      },
      elevation: WidgetStateProperty.resolveWith<double?>(
        (Set<WidgetState> states) {
          return 0.0; // Default elevation
        },
      ),
    );
  }
}
