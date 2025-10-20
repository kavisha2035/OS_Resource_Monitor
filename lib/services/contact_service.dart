import 'package:hive/hive.dart';
import '../models/contact_model.dart';

class ContactService {
  static const String _boxName = 'contacts';

  Future<void> addContact(Contact contact) async {
    final box = Hive.box<Contact>(_boxName);
    await box.add(contact);
  }

  Future<List<Contact>> getContacts() async {
    final box = Hive.box<Contact>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteContact(Contact contact) async {
    await contact.delete();
  }

  Future<void> clearAllContacts() async {
    final box = Hive.box<Contact>(_boxName);
    await box.clear();
  }
}