import 'package:flutter/cupertino.dart';
import 'package:rms_desktop/modal/money.dart';
import 'package:rms_desktop/notifier/money-notifier.dart';

class CashIn extends StatefulWidget {
  const CashIn({Key? key}) : super(key: key);

  @override
  _CashInState createState() => _CashInState();
}

class _CashInState extends State<CashIn> {

  TextEditingController amt = TextEditingController();
  TextEditingController rem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Cash In"),
          trailing: GestureDetector(
            onTap: (){
              Money money = Money();
              money.id = "1";
              money.money = amt.value.text.toString();
              money.inOut = true;
              money.remarks = rem.value.text.toString();
              MoneyController().addItem(money);
              Navigator.pop(context);
            },
            child: Icon(
              CupertinoIcons.add,
            ),
          ),
        ),
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: amt,
                prefix: Icon(CupertinoIcons.money_dollar),
                keyboardType: TextInputType.number,
                autofocus: true,
                cursorColor: CupertinoColors.systemBlue,
                placeholder: "Amount",
                style: TextStyle(color: CupertinoColors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: rem,
                prefix: Icon(CupertinoIcons.lightbulb),
                cursorColor: CupertinoColors.systemBlue,
                placeholder: "Remarks",
                style: TextStyle(color: CupertinoColors.black, fontSize: 20),
              ),
            ),
          ],
        )));
  }
}
