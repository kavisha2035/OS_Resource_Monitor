import 'package:hive/hive.dart';

part 'consignment_model.g.dart';

// @HiveType(typeId: 1)
// class Consignment extends HiveObject {
//   @HiveField(0)
//   late String awbNumber;

//   @HiveField(1)
//   late DateTime date;

//   @HiveField(2)
//   late String consignorName;

//   @HiveField(3)
//   late String consignorPhone;

//   @HiveField(4)
//   late String consigneeName;

//   @HiveField(5)
//   late String consigneePhone;

//   @HiveField(6)
//   late String origin;

//   @HiveField(7)
//   late String destination;

//   @HiveField(8)
//   late String description;

//   @HiveField(9)
//   late bool insurance;

//   @HiveField(10)
//   late int numberOfPieces;

//   @HiveField(11)
//   late double weight;

//   @HiveField(12)
//   late double weightCharge;

//   @HiveField(13)
//   late double declaredValue;

//   @HiveField(14)
//   late String mode;

//   @HiveField(15)
//   late String status;

//   Consignment({
//     required this.awbNumber,
//     required this.date,
//     required this.consignorName,
//     required this.consignorPhone,
//     required this.consigneeName,
//     required this.consigneePhone,
//     required this.origin,
//     required this.destination,
//     required this.description,
//     required this.insurance,
//     required this.numberOfPieces,
//     required this.weight,
//     required this.weightCharge,
//     required this.declaredValue,
//     required this.mode,
//     required this.status,
//   });
// }

/*
Consignment Model

Consignor's Name
Consignor's Phone
Consignee's Address
Consignee's GSTIN
Consignee's Email

Consignee's Name
Consignee's Phone
Consignee's Address
Consignee's GSTIN
Consignee's Email

Origin
Destination
Type
Product
Date

Content Specification
Paperwork Enclosed
Declared Value
No. of Pieces
Actual Weight
Ewaybill Number
Dimensions (LxWxH)
Charged Weight

Center Name
Center Address
Center Phone

AWB Number
Receiver's Name
Receiver's Phone

Risk Surcharge
Total Amount
*/

@HiveType(typeId: 1)
class Consignment extends HiveObject {

  @HiveField(0)
  late String ConsignorName;

  @HiveField(1)
  late String ConsignorPhone;

  @HiveField(2)
  late String ConsigneeAddress;

  @HiveField(3)
  late String ConsigneeGSTIN;

  @HiveField(4)
  late String ConsigneeEmail;

  @HiveField(5)
  late String ConsigneeName;

  @HiveField(6)
  late String ConsigneePhone;

  @HiveField(7)
  late String ConsignorAddress;

  @HiveField(8)
  late String ConsignorGSTIN;

  @HiveField(9)
  late String ConsignorEmail;

  @HiveField(10)
  late String Origin;

  @HiveField(11)
  late String Destination;

  @HiveField(12)
  late String Type;

  @HiveField(13)
  late String Product;

  @HiveField(14)
  late DateTime Date;

  @HiveField(15)
  late String ContentSpecification;

  @HiveField(16)
  late String PaperworkEnclosed;

  @HiveField(17)
  late double DeclaredValue;

  @HiveField(18)
  late int NumberOfPieces;

  @HiveField(19)
  late double ActualWeight;

  @HiveField(20)
  late String EwaybillNumber;

  @HiveField(21)
  late String Dimensions;

  @HiveField(22)
  late double ChargedWeight;

  @HiveField(23)
  late String CenterName;

  @HiveField(24)
  late String CenterAddress;

  @HiveField(25)
  late String CenterPhone;

  @HiveField(26)
  late String AWBNumber;

  @HiveField(27)
  late String ReceiverName;

  @HiveField(28)
  late String ReceiverPhone;

  @HiveField(30)
  late double RiskSurcharge;

  @HiveField(31)
  late double TotalAmount;

  @HiveField(32)
  late String ModeOfPayment; // Online, COD

  Consignment({
    required this.ConsignorName,
    required this.ConsignorPhone,
    required this.ConsigneeAddress,
    required this.ConsigneeGSTIN,
    required this.ConsigneeEmail,
    required this.ConsigneeName,
    required this.ConsigneePhone,
    required this.ConsignorAddress,
    required this.ConsignorGSTIN,
    required this.ConsignorEmail,
    required this.Origin,
    required this.Destination,
    required this.Type,
    required this.Product,
    required this.Date,
    required this.ContentSpecification,
    required this.PaperworkEnclosed,
    required this.DeclaredValue,
    required this.NumberOfPieces,
    required this.ActualWeight,
    required this.EwaybillNumber,
    required this.Dimensions,
    required this.ChargedWeight,
    required this.CenterName,
    required this.CenterAddress,
    required this.CenterPhone,
    required this.AWBNumber,
    required this.ReceiverName,
    required this.ReceiverPhone,
    required this.RiskSurcharge,
    required this.TotalAmount,
    required this.ModeOfPayment,
  });
}