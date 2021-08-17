import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rms_desktop/helper/pdf-invoice-creator.dart';
import 'package:rms_desktop/modal/money.dart';
import 'package:rms_desktop/ui/cash-in.dart';
import 'package:rms_desktop/ui/cash-out.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;
    final items = List<String>.generate(10000, (i) => "Item $i");

    double newBalance = 0.0;
    double cashIn = 0;
    double cashOut = 0;

//    Stream<Money> moneyStream = MoneyController().getItem();
    Box hivebOx = Hive.box("appDb");

    hivebOx.values.forEach((element) {
      if(element.inOut) {
        cashIn = cashIn + double.parse(element.money);
      }
      else{
        //out
        cashOut = cashOut + double.parse(element.money);
      }

      newBalance = cashIn - cashOut;
    });

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Cash Book"),
          trailing: GestureDetector(
              onTap: (){
                showCupertinoDialog(context: context, builder: (BuildContext co) {
                  return CupertinoAlertDialog(actions: [
                    CupertinoButton(onPressed: () {
                      PdfInvoiceCreator().generateInvoice();
                      Navigator.pop(context);
                    },
                      child: Text("Download"),),
                    CupertinoButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      child: Text("Cancel"),)
                  ],title: Text("Download Invoice"),content: Text("Do you want to download the current entry invoice?"),);
                });
              },
              child: Icon(CupertinoIcons.download_circle)),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: width - 20,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: CupertinoColors.systemBlue,
                                    //border: Border.all(color: CupertinoColors.systemGreen)
                                  ),
                                  padding: EdgeInsets.all(25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Net Balance:",
                                            style: TextStyle(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Rs ${newBalance.toString()}",
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: CupertinoColors.white,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  CupertinoIcons.add_circled,
                                                  color: CupertinoColors
                                                      .systemBackground,
                                                ),
                                              ),
                                              Text(
                                                "Total Cash In",
                                                style: TextStyle(
                                                    color:
                                                        CupertinoColors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Rs. ${cashIn.toString()}",
                                                style: TextStyle(
                                                    color:
                                                        CupertinoColors.white),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  CupertinoIcons.minus_circled,
                                                  color: CupertinoColors
                                                      .activeOrange,
                                                ),
                                              ),
                                              Text(
                                                "Total Cash Out",
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .activeOrange,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Rs. ${cashOut.toString()}",
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 0.7 * height,
                        padding: EdgeInsets.only(top: 1,bottom: 70),
                        child: Material(
                            child:
                            (hivebOx.values.length == 0) ?
                                Center(
                                  child: Text("No records found"),
                                ):
                            ListView.builder(
                                itemCount: hivebOx.values.length,
                                itemBuilder: (BuildContext c, int index){
                                  return     (hivebOx.getAt(index).inOut)?
                                  GestureDetector(

                                   onLongPress: () {
                                     showCupertinoDialog(context: context, builder: (BuildContext co) {
                                       return CupertinoAlertDialog(actions: [
                                         CupertinoButton(onPressed: () {
                                           hivebOx.deleteAt(index);
                                           setState(() {

                                           });

                                           Navigator.pop(context);
                                         },
                                         child: Text("Delete"),),
                                         CupertinoButton(onPressed: () {
                                           Navigator.pop(context);
                                         },
                                         child: Text("Cancel"),)
                                       ],title: Text("Delete Entry"),content: Text("Do you want to delete the current entry?"),);
                                     });
                                   },
                                    child: ListTile(
                                      title: Text(hivebOx.getAt(index).money,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        hivebOx.getAt(index).remarks,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      leading: Icon(
                                        CupertinoIcons.add_circled,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ):
                                  GestureDetector(

                                    onLongPress: () {
                                      showCupertinoDialog(context: context, builder: (BuildContext co) {
                                        return CupertinoAlertDialog(actions: [
                                          CupertinoButton(onPressed: () {
                                            hivebOx.deleteAt(index);
                                            setState(() {

                                            });

                                            Navigator.pop(context);
                                          },
                                            child: Text("Delete"),),
                                          CupertinoButton(onPressed: () {
                                            Navigator.pop(context);
                                          },
                                            child: Text("Cancel"),)
                                        ],title: Text("Delete Entry"),content: Text("Do you want to delete the current entry?"),);
                                      });
                                    },
                                    child: ListTile(
                                      title: Text(hivebOx.getAt(index).money,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        hivebOx.getAt(index).remarks,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      leading: Icon(
                                        CupertinoIcons.minus_circled,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );

                                })


                      )
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                left: 0,
                right: 0,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CupertinoButton(
                          color: CupertinoColors.activeGreen,
                          child: Text("Cash In"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext c) => CashIn()));
                          }),
                      CupertinoButton(
                          color: CupertinoColors.destructiveRed,
                          child: Text("Cash Out"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (BuildContext c) => CashOut()));
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
