import 'dart:io';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../models/consignment_model.dart';
import '../providers/consignment_provider.dart';
import 'contact_management_screen.dart';
import 'receipt_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<ConsignmentProvider>(context, listen: false)
          .filterBySearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select a Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF528198),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
      if(context.mounted) {
        Provider.of<ConsignmentProvider>(context, listen: false)
          .filterByDate(pickedDate);
      }
    }
  }

  Future<void> _downloadExcel(BuildContext context, List<Consignment> data) async {
    final excel.Excel workbook = excel.Excel.createExcel();
    final sheet = workbook['Shipments'];

    sheet.appendRow([
      excel.TextCellValue('AWB Number'),
      excel.TextCellValue('Date'),
      excel.TextCellValue('Consignor Name'),
      excel.TextCellValue('Consignee Name'),
      excel.TextCellValue('Product'),
      excel.TextCellValue('Mode of Payment'),
    ]);

    for (var shipment in data) {
      sheet.appendRow([
        excel.TextCellValue(shipment.AWBNumber),
        excel.TextCellValue(DateFormat('yyyy-MM-dd').format(shipment.Date)),
        excel.TextCellValue(shipment.ConsignorName),
        excel.TextCellValue(shipment.ConsigneeName),
        excel.TextCellValue(shipment.Product),
        excel.TextCellValue(shipment.ModeOfPayment),
      ]);
    }

    final bytes = workbook.encode();
    if (bytes == null) return;

    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/shipments_${DateTime.now().microsecondsSinceEpoch}.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    if(context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel file saved to $filePath'),backgroundColor: Colors.green,),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFF3F7FA), const Color(0xFFDDEAF4)],
          ),
        ),
        child: Row(
          children: [
            _buildSidebar(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    if (_selectedDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Showing results for: ${DateFormat.yMMMMd().format(_selectedDate!)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Expanded(child: _buildHistoryList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 94,
      decoration: BoxDecoration(
        color: const Color(0x7F7196A9),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        border: Border.all(color: const Color(0xFF528198)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSidebarIcon(Icons.add_circle, 'New Receipt', () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReceiptScreen()));
          }),
          const SizedBox(height: 20),
          _buildSidebarIcon(Icons.contacts, 'Manage Contacts', () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactManagementScreen()));
          }),
          const SizedBox(height: 20),
          _buildSidebarIcon(Icons.history, 'History', () {}),
        ],
      ),
    );
  }

  Widget _buildSidebarIcon(IconData icon, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: 70,
            height: 70,
            child: Icon(icon, color: const Color(0xFF528198), size: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Shipment History',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFF5D6D7E)),
        ),
        const Spacer(),
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by AWB, Consignor, or Consignee',
              filled: true,
              fillColor: const Color(0xFFF1F4F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF528198)),
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF528198)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.date_range),
          label: const Text('Filter by Date'),
          onPressed: () => _selectDate(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            backgroundColor: const Color(0xFF528198),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Consumer<ConsignmentProvider>(
          builder: (context, provider, _) {
            return Visibility(
              visible: provider.consignments.isNotEmpty && _selectedDate != null,
              child: ElevatedButton.icon(
                icon: Icon(Icons.download),
                label: Text('Download Excel'),
                onPressed: () => _downloadExcel(context, provider.consignments),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  backgroundColor: Color(0xFF528198),
                  foregroundColor: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            setState(() => _selectedDate = null);
            Provider.of<ConsignmentProvider>(context, listen: false).clearFilters();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            backgroundColor: Color(0xFF528198),
            foregroundColor: Colors.white,
          ),
          child: const Text('Clear Filter'),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return Consumer<ConsignmentProvider>(
      builder: (context, provider, child) {
        if (provider.consignments.isEmpty) {
          return const Center(child: Text('No shipments found.', style: TextStyle(fontSize: 24)));
        }
        return ListView.builder(
          itemCount: provider.consignments.length,
          itemBuilder: (context, index) {
            final consignment = provider.consignments[index];
            return _buildHistoryCard(consignment);
          },
        );
      },
    );
  }

  Widget _buildHistoryCard(Consignment shipment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: const Color(0xFFDDEAF4).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF528198)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildInfoItem('AWB Number', shipment.AWBNumber)),
                      Expanded(child: _buildInfoItem('Date', DateFormat.yMMMd().format(shipment.Date))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInfoItem('Consignor Name', shipment.ConsignorName)),
                      Expanded(child: _buildInfoItem('Consignee Name', shipment.ConsigneeName)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInfoItem('Product', shipment.Product)),
                      Expanded(child: _buildInfoItem('Mode of Payment', shipment.ModeOfPayment)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.print, color: Color(0xFF528198)),
                  tooltip: 'Print Receipt',
                  onPressed: () {
                    Provider.of<ConsignmentProvider>(context, listen: false)
                        .generateAndPrintReceipt(shipment);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Delete Consignment',
                  onPressed: () {
                    Provider.of<ConsignmentProvider>(context, listen: false)
                        .deleteConsignment(shipment);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xFF5D6D7E)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF1E1E1E)),
        ),
      ],
    );
  }
}
