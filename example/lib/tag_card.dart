import 'package:example/sliver_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_utils/extensions/date_extensions.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';

class TagCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final TableController? tableController;

  const TagCard({
    Key? key,
    required this.item,
    this.tableController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    dprint(item);
    var hasMpesaCode = item["mpesa_code"] != null;
    var isNameAndAccount = item["account"]?.isNotEmpty ?? false;
    var isNameOnly = item["account"]?.isEmpty ?? false;
    var scope = "Applies to transactions";
    var tagTitle = "@category_name# • @sub_category_name#".interpolate(item);
    var tagType = hasMpesaCode ? "Specific" : "Similar";
    List<String> labels = []; // ["name", "account", "mpesa_code"];
    if (hasMpesaCode) {
      labels.add("@mpesa_code#".interpolate(item));
      scope = "Applies only to transaction id @mpesa_code#".interpolate(item);
    } else {
      labels.add("@name#".interpolate(item));
      if (isNameAndAccount) {
        labels.add("@account#".interpolate(item));
        scope =
            "Applies to all transactions matching @name# and number @account#"
                .interpolate(item);
      } else {
        scope = "Applies to all transactions matching @name#".interpolate(item);
      }
    }

    var created =
        "@created#".interpolate(item).toDate?.toDateTimeFormat("E, dd MMM y");
    var transactions = 10;

    var isSimilar = tagType == "Similar";

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSimilar
              ? theme.colorScheme.surface.withOpacity(0.8)
              : theme.colorScheme.surface.withOpacity(0.8),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      // color: tagType == "Similar Transactions"
      //     ? Colors.blue[50] // Light blue for "Similar Transactions"
      //     : Colors.orange[50], // Light orange for "Specific Transaction"
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Tag Name, Type Badge, and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tag Name and Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tagTitle,
                      style: theme.textTheme.titleLarge,
                      // style: TextStyle(
                      //   fontSize: 18,
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                    // SizedBox(height: 4),
                    // // Badge for Type
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8, vertical: 4),
                    //   decoration: BoxDecoration(
                    //     color: isSimilar
                    //         ? theme.colorScheme.secondary
                    //         : theme.colorScheme.tertiary,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Text(tagType,
                    //       style: theme.textTheme.labelMedium?.copyWith(
                    //           color: isSimilar
                    //               ? theme.colorScheme.onSecondary
                    //               : theme.colorScheme.onTertiary)),
                    // ),
                  ],
                ),
                // Status Icon
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Edit"),
                      onTap: () {
                        if (tableController != null) {
                          tableController?.getData();
                        } else {
                          dprint("No controller");
                        }
                      },
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                      onTap: () {
                        if (tableController != null) {
                          tableController?.deleteItem(item);
                        } else {
                          dprint("No controller");
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 0),
            // Labels (Optional Scope Indicators)
            if (labels.length > 0)
              Wrap(
                spacing: 8,
                children: labels
                    .map((label) => Chip(
                          label: Text(
                            label,
                            style: theme.textTheme.titleSmall,
                          ),
                          backgroundColor: theme.colorScheme.surfaceContainer,
                        ))
                    .toList(),
              ),
            SizedBox(height: 16),

            // Scope Description
            Text(
              scope,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8),
            // Metadata
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSimilar
                        ? theme.colorScheme.secondaryContainer.withOpacity(0.7)
                        : theme.colorScheme.tertiaryContainer.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSimilar
                            ? Icons.account_tree_rounded
                            : Icons.text_snippet_rounded,
                        size: 20,
                        color: isSimilar
                            ? theme.colorScheme.onSecondaryContainer
                                .withOpacity(0.9)
                            : theme.colorScheme.onTertiaryContainer
                                .withOpacity(0.9),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(tagType,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isSimilar
                                ? theme.colorScheme.onSecondaryContainer
                                    .withOpacity(0.9)
                                : theme.colorScheme.onTertiaryContainer
                                    .withOpacity(0.9),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    "$transactions Transactions",
                    style: theme.textTheme.bodySmall,
                  ),
                  icon: Icon(
                    Icons.format_list_numbered,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
