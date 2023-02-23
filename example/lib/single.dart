import 'package:flutter/material.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_tables/text_view.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';

Widget buildImages() => ListView.builder(
      itemCount: 100,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            "${index}",
            style: Get.theme.textTheme.headline4,
          ),
        );
      },
    );

class SingleShopView extends StatelessWidget {
  const SingleShopView({super.key});

  @override
  Widget build(BuildContext context) {
    dprint(Get.arguments);
    var item = Get.arguments["item"];
    var options = Get.arguments["options"] as ListViewOptions;
    return Scaffold(
      appBar: AppBar(
        title: TextView(
          display_message: options.title ?? "",
          data: item,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (item["image"] != null)
              Hero(
                transitionOnUserGestures: true,
                tag: "image${item['id']}",
                child: Image(image: NetworkImage(item["image"])),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextView(
                display_message: options.title ?? "",
                data: item,
                style: Get.theme.textTheme.headline4,
              ),
            ),
            // TextView(
            //   display_message: options.subtitle ?? "",
            //   data: item,
            //   style: Get.theme.textTheme.bodyText2,
            // ),
            MyTable(
              key: Key("item${item['id']}"),
              type: MyTableType.list,
              pageSize: 100,
              options: ListViewOptions(
                  separator: Divider(),
                  physics: const NeverScrollableScrollPhysics(),
                  title: "@full_name#",
                  subtitle: "Manager: @contact_name#\n",
                  trailing: "Contact @contact_phone#"),
              name: 'Shop Branches',
              args: {"shop": "${item['id']}"},
              listTypeUrl: "api/v1/shop-branches/",
            ),

            MyTable(
              key: Key("product${item['id']}"),
              type: MyTableType.list,
              pageSize: 100,
              options: ListViewOptions(
                  separator: Divider(),
                  physics: const NeverScrollableScrollPhysics(),
                  title: "@name#",
                  subtitle: "@description#",
                  trailing: "Requires Serial: @require_serial_number_display#"),
              name: 'Shop Products Defintions',
              // args: {"shop": "${item['id']}"},
              listTypeUrl: "api/v1/shops/${item['id']}/products/",
            ),
          ],
        ),
      ),
    );
  }
}
