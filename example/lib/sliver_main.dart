import 'package:flutter/material.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';

class MainSliverApp extends StatelessWidget {
  const MainSliverApp({super.key});

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
            onItemDelete: (item) async {
              await Future.delayed(Duration(seconds: 5));
              dprint("DOne with cleanup");
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
            listTypeUrl: 'api/v1/shops',
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
