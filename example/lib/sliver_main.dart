import 'package:example/main.dart';
import 'package:example/tag_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';

class MainSliverApp extends StatelessWidget {
  TableController? controller;

  MainSliverApp({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.2,
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Hello world"),
            ),
            // flexibleSpace: ,
          ),
          MyTable(
            type: MyTableType.sliver,
            pageSize: 20,
            enableDelete: true,
            instanceUrl: "api/v1/tagging-rules",
            deleteMessageTemplate:
                "Delete @name# custom rule for @sub_category_name#",
            onItemDelete: (item) async {
              await Future.delayed(Duration(seconds: 2));
              dprint("DOne with cleanup");
            },
            onControllerSetup: (cont) {
              controller = cont;
            },
            itemBuilder: (context, item, options) {
              return TagCard(
                item: item,
                tableController: controller,
              );
              return Text("@name#".interpolate(item));
            },
            options: ListViewOptions(
              // physics: const NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              title: "Customer 2 @name#",
              subtitle: "Branch: @branch_name#"
                  "\nKSH @total_price#"
                  "\n@created#"
                  "\nThemiadaidoa diajod aodnoad adnad nadioad aidoad aidoad adiaod adoadh this is the end of the line.",
              trailing: "",
            ),
            name: 'sliverslaes',
            headers: [
              'branch_name',
              'name',
              "transaction_type_display",
              "total_price"
            ],
            listTypeUrl: 'api/v1/tagging-rules/me',
          ),

          // SliverList.builder(
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text("${index}"),
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
