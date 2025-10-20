import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/contact_model.dart';

class ContactProvider with ChangeNotifier {
  final Box<Contact> _contactBox = Hive.box<Contact>('contacts');

  List<Contact> getContacts() {
    return _contactBox.values.toList();
  }

  void addContact(Contact contact) {
    _contactBox.add(contact);
    notifyListeners();
  }

  void deleteContact(int index) {
    _contactBox.deleteAt(index);
    notifyListeners();
  }

  Contact? getContactByPhone(String phone) {
    try {
      return _contactBox.values.firstWhere((contact) => contact.phone == phone);
    } catch (e) {
      return null;
    }
  }

}