import 'package:example/single.dart';
import 'package:example/sliver_app_bar_single.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_auth/login.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_tables/tables_models.dart';

import 'package:flutter_tables/text_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  Get.put<APIConfig>(APIConfig(
      apiEndpoint: "https://dukapi.roometo.com",
      version: "api/v1",
      clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
      tokenUrl: 'o/token/',
      grantType: "password",
      revokeTokenUrl: 'o/revoke_token/'));
  await GetStorage.init();
  Get.lazyPut(() => AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  late String title;
  var data;
  MyHomePage({super.key, required this.title}) {
    data = {"name": "Mwangi Micha", "age": 30, "title": title};
  }
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    return Obx(
      () => (authController.isAuthenticated$.value)
          ? Scaffold(
              appBar: AppBar(
                title: TextView(
                  data: data,
                  display_message: 'Name: @name , Age: @age#Yrs',
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      authController.logout();
                    },
                    child: const Text("Logout"),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      MyTable(
                        enableDelete: true,
                        enableEdit: true,
                        // pageSize: 3,
                        deleteMessageTemplate: "Delete shop @name# ?",
                        type: MyTableType.list,
                        updateWidget: () => SingleSliverBarWidget(),
                        transformRow: (Map<String, dynamic> value) {
                          if (value.containsKey("created")) {
                            dprint("value");
                            value["created"] = value["created"].split("T")[0];
                          }
                          return value;
                        },
                        itemBuilder: (context, index, options) {
                          return Text("${options?.title}");
                        },
                        preUpdate: (value) {
                          dprint("Goe this shoe");
                          dprint(value);
                          dprint(value.runtimeType);
                          dprint(value["id"]);
                          var name = value?["name"];
                          var fieldValue = "${value["id"]}";
                          var multifields = {
                            "shop": FormChoice(
                              display_name: name,
                              value: fieldValue,
                            )
                          };
                          value["multifield"] = multifields;
                          value["shop"] = "${value["shop"]}";
                          return value;
                        },
                        onSelect: (ListViewOptions options,
                            Map<String, dynamic> item) {
                          dprint(item);
                          Get.to(SingleShopView(),
                              duration: Duration(seconds: 1),
                              arguments: {"item": item, "options": options});
                        },

                        // options: ListViewOptions(
                        //     title: "Customer @name#",
                        //     subtitle: "@branch_name · @transaction_type_display# ",
                        //     trailing: "KSH @total_price#"),

                        options: ListViewOptions(
                            shrinkWrap: true,
                            imageField: "image",
                            physics: NeverScrollableScrollPhysics(),
                            separator: Divider(),
                            title: "Shop @name#",
                            trailing: "@id# Products"
                                "\nBy @created_by#\ndda",
                            subtitle: "Managed by @contact_name#"
                                "\nCall @contact_phone#"
                                "\n@location#"
                                "\n@created#"),
                        // options: ListViewOptions(),

                        name: 'Shops',
                        headers: [
                          'branch_name',
                          'name',
                          "transaction_type_display",
                          "total_price"
                        ],
                        listTypeUrl: 'api/v1/shops',
                      ),
                      MyTable(
                        type: MyTableType.list,
                        pageSize: 10,

                        // onSelect: (ListViewOptions options,
                        //     Map<String, dynamic> item) {
                        //   Get.to(SingleSliverBarWidget(),
                        //       duration: Duration(seconds: 1),
                        //       arguments: {"item": item, "options": options});
                        // },
                        options: ListViewOptions(
                            physics: const NeverScrollableScrollPhysics(),
                            title: "Customer 2 @name#",
                            subtitle: "Branch: @branch_name#"
                                "\nKSH @total_price#"
                                "\n@created#"
                                "\nThemiadaidoa diajod aodnoad adnad nadioad aidoad aidoad adiaod adoadh this is the end of the line.",
                            trailing: ""),
                        name: 'Sales',
                        headers: [
                          'branch_name',
                          'name',
                          "transaction_type_display",
                          "total_price"
                        ],
                        listTypeUrl: 'api/v1/sales',
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginWidget(),
                ],
              ),
            ),
    );
  }
}
