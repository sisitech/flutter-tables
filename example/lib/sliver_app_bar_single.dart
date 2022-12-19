import 'package:flutter/material.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:get/get.dart';
import 'package:flutter_tables/tables_single_view.dart';

const image_url = "https://sisitech.com/images/logo-dark.png";

class SingleSliverBarWidget extends StatelessWidget {
  const SingleSliverBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final title = 'GeeksforGeeks';
    var item = {"id": 6};

    return Scaffold(
        body: MyTableSliverTabbedView(
      title: Text("Sisitech"),
      tabBarPinned: false,
      // sliverBarPinned: true,
      sliverBarFloating: false,
      tabBarFloating: true,
      expandedHeight: 200,
      tabsViewChildren: [
        Text("data"),
        SingleChildScrollView(
          child: Column(
            children: [
              buildImages(count: 130),
              // Card(
              //   child: MyTable(
              //     key: Key("item${item['id']}"),
              //     type: MyTableType.list,
              //     pageSize: 100,
              //     options: ListViewOptions(
              //         separator: Divider(),
              //         physics: const NeverScrollableScrollPhysics(),
              //         title: "@full_name#",
              //         subtitle: "Manager: @contact_name#\n",
              //         trailing: "Contact @contact_phone#"),
              //     name: 'Shop Branches',
              //     // args: {"shop": "${item['id']}"},
              //     listTypeUrl: "api/v1/sales/",
              //   ),
              // ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Card(
            child: MyTable(
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
              // args: {"shop": "${item['id']}"},
              listTypeUrl: "api/v1/sales/",
            ),
          ),
        ),
        // SingleChildScrollView(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       ListView.builder(
        //         itemCount: 40,
        //         shrinkWrap: true,
        //         itemBuilder: (context, index) {
        //           return Text(
        //             "Product ${index}",
        //             style: Get.theme.textTheme.headline4,
        //           );
        //         },
        //       ),
        //       // buildImages()
        //     ],
        //   ),
        // ),
        Text("Tabl 3"),
      ],
      tabs: [
        Tab(
          child: Card(
            child: Text("AD"),
          ),
          icon: Icon(Icons.list),
          // text: "Purchases",
        ),
        Tab(
          icon: Icon(Icons.attach_money_outlined),
          text: "Sales",
        ),
        Tab(
          icon: Icon(Icons.list),
          text: "Lost",
        ),
      ],
      // expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(image_url),
        title: Text(""),
        collapseMode: CollapseMode.parallax,
      ),
    ) //CustonScrollView
        ); //MaterialApp
  }
}

class SliverBasicAPp extends StatelessWidget {
  const SliverBasicAPp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          // title: const Text("Sliver App Bar"),
          expandedHeight: 250,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(image_url),
            // title: Text("Sisitech"),
            collapseMode: CollapseMode.parallax,
          ),
        ),
        buildImages()
      ],
    );
  }
}

Widget buildImages({int count = 50}) => ListView.builder(
    itemCount: count,
    shrinkWrap: true,
    primary: false,
    itemBuilder: (context, index) {
      return Center(
        child: Text(
          "${index}",
          style: Get.theme.textTheme.headline4,
        ),
      );
    });
