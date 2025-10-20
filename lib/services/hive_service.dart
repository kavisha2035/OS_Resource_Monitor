import 'package:hive/hive.dart';
import '../models/consignment_model.dart';

class HiveService {
  final Box<Consignment> _consignmentBox = Hive.box<Consignment>('consignments');

  Future<void> addConsignment(Consignment consignment) async {
    await _consignmentBox.add(consignment);
  }

  List<Consignment> getConsignments() {
    return _consignmentBox.values.toList();
  }

  Future<void> deleteConsignment(Consignment consignment) async {
    await consignment.delete();
  }

  Future<void> updateConsignment(dynamic key, Consignment updatedConsignment) async {
    await _consignmentBox.put(key, updatedConsignment);
  }
}
