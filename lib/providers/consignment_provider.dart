import 'package:flutter/material.dart';
import '../models/consignment_model.dart';
import '../services/auth_service.dart';
import '../services/hive_service.dart';
import '../services/pdf_receipt_service.dart';

class ConsignmentProvider with ChangeNotifier {
  final HiveService _hiveService = HiveService();
  final AuthService _authService = AuthService();
  final PdfReceiptService _pdfReceiptService = PdfReceiptService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  List<Consignment> _allConsignments = [];
  List<Consignment> _filteredConsignments = [];
  DateTime? _selectedDate;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  List<Consignment> get consignments => _filteredConsignments;

  ConsignmentProvider() {
    loadConsignments();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    _isAuthenticated = await _authService.login(username, password);
    _isLoading = false;
    notifyListeners();
    return _isAuthenticated;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void loadConsignments() {
    _allConsignments = _hiveService.getConsignments();
    _applyFilters();
  }

  Future<void> addConsignment(Consignment consignment) async {
    await _hiveService.addConsignment(consignment);
    loadConsignments();
  }

  Future<void> deleteConsignment(Consignment consignment) async {
    await _hiveService.deleteConsignment(consignment);
    loadConsignments();
  }

  Future<void> generateAndPrintReceipt(Consignment consignment) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _pdfReceiptService.generateAndPrintReceipt(consignment);
    } catch (e) {
      debugPrint("Error generating PDF: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  void _applyFilters({String? query}) {
    _filteredConsignments = _allConsignments;

    if (query != null && query.isNotEmpty) {
      final lowerCaseQuery = query.toLowerCase();
      _filteredConsignments = _filteredConsignments.where((c) {
        return c.AWBNumber.toLowerCase().contains(lowerCaseQuery) ||
            c.ConsignorName.toLowerCase().contains(lowerCaseQuery) ||
            c.ConsigneeName.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }

    if (_selectedDate != null) {
      _filteredConsignments = _filteredConsignments.where((c) =>
      c.Date.year == _selectedDate!.year &&
          c.Date.month == _selectedDate!.month &&
          c.Date.day == _selectedDate!.day
      ).toList();
    }

    notifyListeners();
  }

  void filterBySearch(String query) {
    _applyFilters(query: query);
  }

  void filterByDate(DateTime? date) {
    _selectedDate = date;
    _applyFilters();
  }

  void clearFilters() {
    _selectedDate = null;
    _applyFilters();
  }
}
