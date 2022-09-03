import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salami_app/models/salami.dart';

import 'helper.dart';

class ScreenGroom extends StatefulWidget {
  const ScreenGroom({Key? key}) : super(key: key);

  @override
  _ScreenGroomState createState() => _ScreenGroomState();
}

class _ScreenGroomState extends State<ScreenGroom> {
  double total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groom Side"),
        actions: [Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 5),
            child: Text("${total.round()}  RS", style: normal_h3Style_bold,))],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: groomRef.orderBy("timestamp", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CupertinoActivityIndicator();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return NotFound(
                message: "No Internet Connection",
                assetImage: "assets/images/no_connection.png",
              );
            }

            total = 0;
            var salamis = snapshot.data!.docs.map((e) => Salami.fromMap(e.data() as Map<String, dynamic>)).toList();

            salamis.forEach((element) {
              total += element.amount;
              print(element.amount.toString());
            });
            print(total);

            return salamis.isNotEmpty
                ? ListView.builder(
                  itemBuilder: (_, index) {
                    final salami = salamis[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onLongPress: () {
                          String name = salami.name;
                          double amount = salami.amount;
                          double updatedAmount = salami.amount;

                          String updatedName = name;
                          int timestamp = salami.timestamp;

                          Get.defaultDialog(
                              title: "Update",
                              content: Column(
                                children: [
                                  CustomInputField(
                                    label: "Name",
                                    onChange: (value) {
                                      updatedName = value.toString();
                                    },
                                    text: name,
                                    isPasswordField: false,
                                    keyboardType: TextInputType.name,
                                  ),
                                  CustomInputField(
                                    label: "Salami",
                                    onChange: (value) {
                                      if (value != null) {
                                        updatedAmount = double.parse(value);
                                      }
                                    },
                                    text: amount.toString(),
                                    isPasswordField: false,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                              textConfirm: "Update",
                              onConfirm: () {
                                var salami = Salami(id: timestamp.toString(), amount: updatedAmount, timestamp: timestamp, name: updatedName);
                                if (updatedAmount == 0 || updatedName.isEmpty) {
                                  Get.snackbar("Alert", "Not allowed");
                                  return;
                                }
                                groomRef.doc(timestamp.toString()).set(salami.toMap()).then((value) {
                                  Get.back();
                                });
                              },
                              textCancel: "Cancel",
                              onCancel: () {
                                Get.back();
                              });
                        },
                        title: Text(
                          salami.name,
                          style: normal_h2Style_bold,
                        ),
                        trailing: Text(timestampToDateFormat(salami.timestamp, "hh:mm a")),
                        subtitle: Text(
                          salami.amount.toString(),
                          style: normal_h3Style,
                        ),
                      ),
                    );
                  },
                  itemCount: salamis.length,
                  shrinkWrap: true,
                )
                : NotFound(
                    message: "No data",
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          String name = "";
          double amount = 0;
          int timestamp = DateTime.now().millisecondsSinceEpoch;

          Get.defaultDialog(
              content: Column(
                children: [
                  CustomInputField(
                    label: "Name",
                    onChange: (value) {
                      name = value.toString();
                    },
                    isPasswordField: false,
                    keyboardType: TextInputType.name,
                  ),
                  CustomInputField(
                    label: "Salami",
                    onChange: (value) {
                      if (value != null) {
                        amount = double.parse(value);
                      }
                    },
                    isPasswordField: false,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              textConfirm: "Add",
              onConfirm: () {
                var salami = Salami(id: timestamp.toString(), amount: amount, timestamp: timestamp, name: name);
                if (amount == 0 || name.isEmpty) {
                  Get.snackbar("Alert", "Not allowed");
                  return;
                }
                groomRef.doc(timestamp.toString()).set(salami.toMap()).then((value) {
                  Get.back();
                });
              },
              textCancel: "Cancel",
              onCancel: () {
                Get.back();
              });
        },
      ),
    );
  }
}
