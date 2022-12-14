library flutter_tables;

import 'package:flutter/material.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_tables/tables_controller.dart';

class TextView extends StatelessWidget {
  final String display_message;
  final Map<String, dynamic>? data;
  final String startFiedSymbol;
  final String endFiedSymbol;

  TextView({
    super.key,
    required this.display_message,
    this.startFiedSymbol = "@",
    this.endFiedSymbol = "#",
    this.data,
  }) {
    // dprint(display_message);
    // dprint(data);
  }

  @override
  Widget build(BuildContext context) {
    return Text(getFieldValue());
  }

  var charachtersToRemove = [" ", "@", "#"];

  getFieldValue() {
    if (display_message == null) {
      return "Noa";
    }
    RegExp regExp = new RegExp(
      r"@(.*?)[ ,#,]",
      caseSensitive: false,
      multiLine: false,
    );
    var variables = [];
    // dprint("Matching");
    var mateches = regExp.allMatches(display_message);

    var parsedMatches = mateches.map(
      (e) {
        var match = display_message.substring(e.start, e.end);
        var name = match
            .split("")
            .map((e) => charachtersToRemove.contains(e) ? "" : e)
            .join("");
        return {
          "match": match.trim(),
          "name": name,
          "value": getMatchValue(name)
        };
      },
      // (e) => e.,
    );
    // dprint(parsedMatches);

    var parsedMessage = display_message;
    parsedMatches.forEach((value) {
      parsedMessage =
          parsedMessage.replaceAll(value["match"], "${value["value"]}");
    });
    // dprint(parsedMessage);
    // dprint(DateTime.now());
    return parsedMessage;
    return "Not implemented";
  }

  getMatchValue(String matchName) {
    if (data == null) {
      return "@${matchName}# No Data";
    }
    if (data!.containsKey(matchName)) {
      return data?[matchName];
    }
    return "No Idea ${matchName}";
  }
}
