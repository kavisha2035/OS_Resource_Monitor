// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consignment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsignmentAdapter extends TypeAdapter<Consignment> {
  @override
  final int typeId = 1;

  @override
  Consignment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Consignment(
      ConsignorName: fields[0] as String,
      ConsignorPhone: fields[1] as String,
      ConsigneeAddress: fields[2] as String,
      ConsigneeGSTIN: fields[3] as String,
      ConsigneeEmail: fields[4] as String,
      ConsigneeName: fields[5] as String,
      ConsigneePhone: fields[6] as String,
      ConsignorAddress: fields[7] as String,
      ConsignorGSTIN: fields[8] as String,
      ConsignorEmail: fields[9] as String,
      Origin: fields[10] as String,
      Destination: fields[11] as String,
      Type: fields[12] as String,
      Product: fields[13] as String,
      Date: fields[14] as DateTime,
      ContentSpecification: fields[15] as String,
      PaperworkEnclosed: fields[16] as String,
      DeclaredValue: fields[17] as double,
      NumberOfPieces: fields[18] as int,
      ActualWeight: fields[19] as double,
      EwaybillNumber: fields[20] as String,
      Dimensions: fields[21] as String,
      ChargedWeight: fields[22] as double,
      CenterName: fields[23] as String,
      CenterAddress: fields[24] as String,
      CenterPhone: fields[25] as String,
      AWBNumber: fields[26] as String,
      ReceiverName: fields[27] as String,
      ReceiverPhone: fields[28] as String,
      RiskSurcharge: fields[30] as double,
      TotalAmount: fields[31] as double,
      ModeOfPayment: fields[32] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Consignment obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.ConsignorName)
      ..writeByte(1)
      ..write(obj.ConsignorPhone)
      ..writeByte(2)
      ..write(obj.ConsigneeAddress)
      ..writeByte(3)
      ..write(obj.ConsigneeGSTIN)
      ..writeByte(4)
      ..write(obj.ConsigneeEmail)
      ..writeByte(5)
      ..write(obj.ConsigneeName)
      ..writeByte(6)
      ..write(obj.ConsigneePhone)
      ..writeByte(7)
      ..write(obj.ConsignorAddress)
      ..writeByte(8)
      ..write(obj.ConsignorGSTIN)
      ..writeByte(9)
      ..write(obj.ConsignorEmail)
      ..writeByte(10)
      ..write(obj.Origin)
      ..writeByte(11)
      ..write(obj.Destination)
      ..writeByte(12)
      ..write(obj.Type)
      ..writeByte(13)
      ..write(obj.Product)
      ..writeByte(14)
      ..write(obj.Date)
      ..writeByte(15)
      ..write(obj.ContentSpecification)
      ..writeByte(16)
      ..write(obj.PaperworkEnclosed)
      ..writeByte(17)
      ..write(obj.DeclaredValue)
      ..writeByte(18)
      ..write(obj.NumberOfPieces)
      ..writeByte(19)
      ..write(obj.ActualWeight)
      ..writeByte(20)
      ..write(obj.EwaybillNumber)
      ..writeByte(21)
      ..write(obj.Dimensions)
      ..writeByte(22)
      ..write(obj.ChargedWeight)
      ..writeByte(23)
      ..write(obj.CenterName)
      ..writeByte(24)
      ..write(obj.CenterAddress)
      ..writeByte(25)
      ..write(obj.CenterPhone)
      ..writeByte(26)
      ..write(obj.AWBNumber)
      ..writeByte(27)
      ..write(obj.ReceiverName)
      ..writeByte(28)
      ..write(obj.ReceiverPhone)
      ..writeByte(30)
      ..write(obj.RiskSurcharge)
      ..writeByte(31)
      ..write(obj.TotalAmount)
      ..writeByte(32)
      ..write(obj.ModeOfPayment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsignmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
