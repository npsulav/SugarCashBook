import 'package:hive/hive.dart';

part 'money.g.dart';

@HiveType(typeId: 0)
class Money {
  @HiveField(0)
  late String id;

  @HiveField((1))
  late String money;

  @HiveField((2))
  late String remarks;

  @HiveField((3))
  late bool inOut;
}
