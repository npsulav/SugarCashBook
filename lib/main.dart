import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rms_desktop/modal/money.dart';
import 'package:rms_desktop/ui/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(MoneyAdapter());
  final Box<dynamic> db = await Hive.openBox('appDB');

  runApp(
    CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    )
  );
}
