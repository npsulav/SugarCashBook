///Dart import
import 'dart:io';

///Package imports
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:intl/intl.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

///To save the pdf file in the device
class FileSaveHelper {
  //static const MethodChannel _platformCall = MethodChannel('launchFile');

  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {

      final Directory? directory = await getExternalStorageDirectory();
      path = directory!.path;
      print(path);
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String fileNames = 'CashbookReport' +format.format(DateTime.now()).toString().replaceAll(" ", "").replaceAll(",", "")+'.pdf';
    final File file =
    File(Platform.isWindows ? '$path\\$fileNames' : '$path/$fileNames');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      final Map<String, String> argument = <String, String>{
        'file_path': '$path/$fileNames'
      };

    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileNames'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileNames'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileNames'],
          runInShell: true);
    }

    _launchURL(url) async {
     await _launchURL(url);
    }

    _launchURL(path!+'/'+fileNames);


  }

}