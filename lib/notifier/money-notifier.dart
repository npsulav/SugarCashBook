import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:rms_desktop/modal/money.dart';

class MoneyController extends ChangeNotifier{

  List _inventoryList = <Money>[];
  List get inventoryList => _inventoryList;

  addItem(Money item) async {
    var box = await Hive.openBox('appDb');
    box.add(item);
    notifyListeners();
  }

  getItem() async {
    final box = await Hive.openBox('appDb');
    _inventoryList = box.values.toList();
    notifyListeners();
  }
}
