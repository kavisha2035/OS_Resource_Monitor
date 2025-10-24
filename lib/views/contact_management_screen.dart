import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../models/contact_model.dart';
import '../services/contact_service.dart';

class ContactManagementScreen extends StatefulWidget {
  @override
  _ContactManagementScreenState createState() => _ContactManagementScreenState();
}

class _ContactManagementScreenState extends State<ContactManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstinController = TextEditingController();
  final _emailController = TextEditingController();
  final _OriginController = TextEditingController();

  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final service = ContactService();
    final list = await service.getContacts();
    setState(() => _contacts = list);
  }

  Future<void> _addContact() async {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        Origin: _OriginController.text.trim(),
        gstin: _gstinController.text.trim().isNotEmpty ? _gstinController.text.trim() : null,
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      );
      await ContactService().addContact(contact);
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
      _gstinController.clear();
      _emailController.clear();
      _loadContacts();
    }
  }

  Future<void> _deleteContact(Contact contact) async {
    await contact.delete();
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Contacts'),
        backgroundColor: const Color(0xFF528198),
      ),
      body: Container(
        color: const Color(0xFFF3F7FA),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Contact',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Name'),
                      validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: _inputDecoration('Phone'),
                      validator: (val) => val == null || val.isEmpty ? 'Enter phone' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _addressController,
                      decoration: _inputDecoration('Address'),
                      validator: (val) => val == null || val.isEmpty ? 'Enter address' : null,
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _OriginController,
                      decoration: _inputDecoration('Origin'),
                      validator: (val) => val == null || val.isEmpty ? 'Enter origin' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _gstinController,
                      decoration: _inputDecoration('GSTIN (Optional)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email (Optional)'),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addContact,
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF528198),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Saved Contacts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _contacts.isEmpty
                  ? const Center(child: Text('No contacts added yet.'))
                  : ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Card(
                    color: Color(0xFFF1F4F9),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF528198)),
                    ),
                    child: ListTile(
                      title: Text(contact.name),
                      subtitle: Text('${contact.phone} • ${contact.email ?? ''}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteContact(contact),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF528198)),
      ),
    );
  }
}