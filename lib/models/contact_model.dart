import 'package:hive/hive.dart';
part 'contact_model.g.dart';

/*
Consignor's Name
Consignor's Phone
Consignee's Address
Consignee's GSTIN
Consignee's Email
*/

@HiveType(typeId: 2)
class Contact extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String phone;

  @HiveField(2)
  late String address;

  @HiveField(3)
  late String? gstin;

  @HiveField(4)
  late String? email;

  @HiveField(5)
  late String Origin;

  Contact({
    required this.name,
    required this.phone,
    required this.address,
    this.gstin,
    this.email,
    required this.Origin,
  });
}
