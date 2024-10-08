import 'dart:async';

import 'package:example/single.dart';
import 'package:example/sliver_app_bar_single.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'internalization/translate.dart';
import 'sliver_main.dart';

void main() async {
  Get.put<APIConfig>(
    APIConfig(
        apiEndpoint: "https://dukapi.roometo.com",
        version: "api/v1",
        clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
        tokenUrl: 'o/token/',
        grantType: "password",
        revokeTokenUrl: 'o/revoke_token/'),
  );
  await GetStorage.init();
  Get.lazyPut(() => AuthController());
  Get.put(NetworkStatusController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      translations: AppTranslations(),
      locale: const Locale('swa', 'KE'),
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      // home: MainSliverApp(),
    );
  }
}

getAppBar(authController, data) => AppBar(
      title: Text(
        'Name',
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            authController.logout();
          },
          child: const Text("Logout"),
        )
      ],
    );

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var data = {"name": "Mwangi Micha", "age": 30, "title": "Hello therer"};

    AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: getAppBar(authController, data),
      body: SafeArea(
          child: Center(
        child: TextView(
          display_message: "hello_one".tr,
          data: data,
        ),
      )),
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
              appBar: getAppBar(authController, data),
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MyTable(
                    //   enableDelete: true,
                    //   enableEdit: true,
                    //   showCount: false,
                    //   pageSize: 3,
                    //   deleteMessageTemplate: "Delete shop @name# ?",
                    //   type: MyTableType.list,
                    //   updateWidget: () => SingleSliverBarWidget(),
                    //   transformRow: (Map<String, dynamic> value) {
                    //     if (value.containsKey("created")) {
                    //       dprint("value");
                    //       value["created"] = value["created"].split("T")[0];
                    //     }
                    //     return value;
                    //   },
                    //   data: [
                    //     {
                    //       "name": "Meiu",
                    //       "id": 1,
                    //     }
                    //   ],
                    //   options: ListViewOptions(
                    //     shrinkWrap: true,
                    //     // itemPadding: EdgeInsets.zero,
                    //     imageField: "image",

                    //     physics: NeverScrollableScrollPhysics(),
                    //     // separator: SizedBox(),
                    //     title: "Shop's name @name#",
                    //     trailing: "@id# Products"
                    //         "\nBy @created_by#\ndda",
                    //     subtitle: "Managed by @contact_name#",
                    //   ),
                    //   // itemBuilder: (context, item, options) {
                    //   //   return Padding(
                    //   //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //   //     child: ListTile(
                    //   //       leading: !(options?.imageField != null &&
                    //   //               item[options?.imageField ?? ""] != null)
                    //   //           ?
                    //   //           // Icon(Icons.holiday_village)
                    //   //           Text(
                    //   //               item?["name"][0] ?? "",
                    //   //               style: TextStyle(
                    //   //                 fontSize: 30,
                    //   //                 fontWeight: FontWeight.bold,
                    //   //               ),
                    //   //             )
                    //   //           : CircleAvatar(
                    //   //               child: Image.network(
                    //   //                 item[options?.imageField ?? ""] ?? "",
                    //   //                 fit: BoxFit.fill,
                    //   //               ),
                    //   //             ),
                    //   //       title: TextView(
                    //   //         data: item,
                    //   //         display_message: options?.title ?? "",
                    //   //       ),
                    //   //       subtitle: TextView(
                    //   //         data: item,
                    //   //         display_message: options?.subtitle ?? "",
                    //   //       ),
                    //   //     ),
                    //   //   );
                    //   //   return Text("${options?.title}");
                    //   // },
                    //   preUpdate: (value) {
                    //     dprint("Goe this shoe");
                    //     dprint(value);
                    //     dprint(value.runtimeType);
                    //     dprint(value["id"]);
                    //     var name = value?["name"];
                    //     var fieldValue = "${value["id"]}";
                    //     var multifields = {
                    //       "shop": FormChoice(
                    //         display_name: name,
                    //         value: fieldValue,
                    //       )
                    //     };
                    //     value["multifield"] = multifields;
                    //     value["shop"] = "${value["shop"]}";
                    //     return value;
                    //   },
                    //   onSelect:
                    //       (ListViewOptions options, Map<String, dynamic> item) {
                    //     dprint(item);
                    //     Get.to(SingleShopView(),
                    //         duration: Duration(seconds: 1),
                    //         arguments: {"item": item, "options": options});
                    //   },

                    //   // options: ListViewOptions(
                    //   //     title: "Customer @name#",
                    //   //     subtitle: "@branch_name · @transaction_type_display# ",
                    //   //     trailing: "KSH @total_price#"),

                    //   // options: ListViewOptions(),

                    //   name: 'Shops',
                    //   headers: [
                    //     'branch_name',
                    //     'name',
                    //     "transaction_type_display",
                    //     "total_price"
                    //   ],
                    //   listTypeUrl: 'api/v1/shops',
                    // ),
                    MyTable(
                      type: MyTableType.list,
                      pageSize: 2,
                      enableDelete: true,
                      onItemDelete: (item) async {
                        await Future.delayed(Duration(seconds: 5));
                        dprint("DOne with cleanup");
                      },
                      options: ListViewOptions(
                        physics: const NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.horizontal,
                        title: "Customer 2 @name#",
                        subtitle: "Branch: @branch_name#"
                            "\nKSH @total_price#"
                            "\n@created#"
                            "\nThemiadaidoa diajod aodnoad adnad nadioad aidoad aidoad adiaod adoadh this is the end of the line.",
                        trailing: "",
                      ),
                      name: 'Sales1',
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
