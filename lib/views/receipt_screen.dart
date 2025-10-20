import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/consignment_model.dart';
import '../providers/consignment_provider.dart';
import '../providers/contact_provider.dart';

class ReceiptScreen extends StatefulWidget {
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    // Consignor Details
    'consignorName': TextEditingController(),
    'consignorPhone': TextEditingController(),
    'consignorAddress': TextEditingController(),
    'consignorGSTIN': TextEditingController(),
    'consignorEmail': TextEditingController(),
    
    // Consignee Details
    'consigneeName': TextEditingController(),
    'consigneePhone': TextEditingController(),
    'consigneeAddress': TextEditingController(),
    'consigneeGSTIN': TextEditingController(),
    'consigneeEmail': TextEditingController(),
    
    // Origin & Destination
    'origin': TextEditingController(),
    'destination': TextEditingController(),
    'type': TextEditingController(),
    
    // Package Details
    'contentSpecification': TextEditingController(),
    'paperworkEnclosed': TextEditingController(),
    'declaredValue': TextEditingController(),
    'numberOfPieces': TextEditingController(),
    'actualWeight': TextEditingController(),
    'ewaybillNumber': TextEditingController(),
    'dimensions': TextEditingController(),
    'chargedWeight': TextEditingController(),
    
    // AWB & Receiver Details
    'awbNumber': TextEditingController(),
    'receiverName': TextEditingController(),
    'receiverPhone': TextEditingController(),
    
    // Financial Details
    'riskSurcharge': TextEditingController(),
    'totalAmount': TextEditingController(),
  };

  // Dropdown values
  String? _selectedProduct;
  String? _selectedModeOfPayment;
  
  final List<String> _productOptions = [
    'Express',
    'Air Cargo',
    'Surface',
    'Premium',
    'International',
  ];
  
  final List<String> _modeOfPaymentOptions = [
    'Online',
    'COD',
  ];

  // Contact lookup functionality
  Timer? _consignorPhoneTimer;
  Timer? _consigneePhoneTimer;
  bool _isConsignorContactFound = false;
  bool _isConsigneeContactFound = false;

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    _consignorPhoneTimer?.cancel();
    _consigneePhoneTimer?.cancel();
    super.dispose();
  }

  void _lookupContactByPhone(String phone, String contactType) {
    if (phone.length == 10 && RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      final contactProvider = Provider.of<ContactProvider>(context, listen: false);
      final contact = contactProvider.getContactByPhone(phone);
      
      if (contact != null) {
        setState(() {
          if (contactType == 'consignor') {
            _isConsignorContactFound = true;
            _controllers['consignorName']!.text = contact.name;
            _controllers['consignorAddress']!.text = contact.address;
            _controllers['consignorGSTIN']!.text = contact.gstin ?? '';
            _controllers['consignorEmail']!.text = contact.email ?? '';
          } else if (contactType == 'consignee') {
            _isConsigneeContactFound = true;
            _controllers['consigneeName']!.text = contact.name;
            _controllers['consigneeAddress']!.text = contact.address;
            _controllers['consigneeGSTIN']!.text = contact.gstin ?? '';
            _controllers['consigneeEmail']!.text = contact.email ?? '';
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contact found: ${contact.name}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          if (contactType == 'consignor') {
            _isConsignorContactFound = false;
          } else if (contactType == 'consignee') {
            _isConsigneeContactFound = false;
          }
        });
      }
    }
  }

  void _onConsignorPhoneChanged(String phone) {
    _consignorPhoneTimer?.cancel();
    _consignorPhoneTimer = Timer(const Duration(milliseconds: 500), () {
      _lookupContactByPhone(phone, 'consignor');
    });
  }

  void _onConsigneePhoneChanged(String phone) {
    _consigneePhoneTimer?.cancel();
    _consigneePhoneTimer = Timer(const Duration(milliseconds: 500), () {
      _lookupContactByPhone(phone, 'consignee');
    });
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (value.length != 10) {
      return 'Phone number must be exactly 10 digits';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  void _generateReceipt() async {
    if (_formKey.currentState!.validate()) {
      // Validate dropdown selections
      if (_selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a Product'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (_selectedModeOfPayment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a Mode of Payment'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final provider = Provider.of<ConsignmentProvider>(context, listen: false);

      final newConsignment = Consignment(
        ConsignorName: _controllers['consignorName']!.text,
        ConsignorPhone: _controllers['consignorPhone']!.text,
        ConsignorAddress: _controllers['consignorAddress']!.text,
        ConsignorGSTIN: _controllers['consignorGSTIN']!.text,
        ConsignorEmail: _controllers['consignorEmail']!.text,
        ConsigneeName: _controllers['consigneeName']!.text,
        ConsigneePhone: _controllers['consigneePhone']!.text,
        ConsigneeAddress: _controllers['consigneeAddress']!.text,
        ConsigneeGSTIN: _controllers['consigneeGSTIN']!.text,
        ConsigneeEmail: _controllers['consigneeEmail']!.text,
        Origin: _controllers['origin']!.text,
        Destination: _controllers['destination']!.text,
        Type: _controllers['type']!.text,
        Product: _selectedProduct!,
        Date: DateTime.now(),
        ContentSpecification: _controllers['contentSpecification']!.text,
        PaperworkEnclosed: _controllers['paperworkEnclosed']!.text,
        DeclaredValue: double.tryParse(_controllers['declaredValue']!.text) ?? 0.0,
        NumberOfPieces: int.tryParse(_controllers['numberOfPieces']!.text) ?? 0,
        ActualWeight: double.tryParse(_controllers['actualWeight']!.text) ?? 0.0,
        EwaybillNumber: _controllers['ewaybillNumber']!.text,
        Dimensions: _controllers['dimensions']!.text,
        ChargedWeight: double.tryParse(_controllers['chargedWeight']!.text) ?? 0.0,
        CenterName: "Ahmedabad",
        CenterAddress: "Shyamal Cross Road, Ahmedabad",
        CenterPhone: "079-12345678",
        AWBNumber: _controllers['awbNumber']!.text,
        ReceiverName: "",
        ReceiverPhone: "",
        RiskSurcharge: double.tryParse(_controllers['riskSurcharge']!.text) ?? 0.0,
        TotalAmount: double.tryParse(_controllers['totalAmount']!.text) ?? 0.0,
        ModeOfPayment: _selectedModeOfPayment!,
      );

      await provider.addConsignment(newConsignment);
      await provider.generateAndPrintReceipt(newConsignment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt Saved and Print Dialog Opened.'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
        _controllers.forEach((_, controller) => controller.clear());
        // Reset dropdowns and contact flags
        setState(() {
          _selectedProduct = null;
          _selectedModeOfPayment = null;
          _isConsignorContactFound = false;
          _isConsigneeContactFound = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Consignment'),
        backgroundColor: const Color(0xFF528198),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3F7FA), Color(0xFFDDEAF4)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Use a more compact grid layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth > 1200;
                    final isMediumScreen = constraints.maxWidth > 800;
                    
                    if (isWideScreen) {
                      // 3 columns for wide screens
                      return _buildThreeColumnLayout(constraints.maxWidth);
                    } else if (isMediumScreen) {
                      // 2 columns for medium screens
                      return _buildTwoColumnLayout(constraints.maxWidth);
                    } else {
                      // Single column for narrow screens
                      return _buildSingleColumnLayout(constraints.maxWidth);
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Generate Receipt Button
                Container(
                  width: screenWidth < 600 ? screenWidth * 0.9 : 400,
                  child: Consumer<ConsignmentProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton.icon(
                        icon: provider.isLoading ? const SizedBox.shrink() : const Icon(Icons.receipt_long),
                        label: Text(provider.isLoading ? 'Generating...' : 'Generate Receipt'),
                        onPressed: provider.isLoading ? null : _generateReceipt,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF528198),
                          foregroundColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThreeColumnLayout(double screenWidth) {
    final sectionWidth = (screenWidth - 80) / 3; // 3 columns with spacing
    
    return Column(
      children: [
        // Row 1: Consignor, Consignee, Shipment
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildConsignorSection(sectionWidth)),
            const SizedBox(width: 16),
            Expanded(child: _buildConsigneeSection(sectionWidth)),
            const SizedBox(width: 16),
            Expanded(child: _buildShipmentSection(sectionWidth)),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2: Package Details (spans 2 columns) + AWB & Financial
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildPackageSection(sectionWidth * 2)),
            const SizedBox(width: 16),
            Expanded(child: _buildAWBFinancialSection(sectionWidth)),
          ],
        ),
      ],
    );
  }

  Widget _buildTwoColumnLayout(double screenWidth) {
    final sectionWidth = (screenWidth - 48) / 2; // 2 columns with spacing
    
    return Column(
      children: [
        // Row 1: Consignor + Consignee
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildConsignorSection(sectionWidth)),
            const SizedBox(width: 16),
            Expanded(child: _buildConsigneeSection(sectionWidth)),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2: Shipment + AWB & Financial
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildShipmentSection(sectionWidth)),
            const SizedBox(width: 16),
            Expanded(child: _buildAWBFinancialSection(sectionWidth)),
          ],
        ),
        const SizedBox(height: 16),
        // Row 3: Package Details (full width)
        _buildPackageSection(screenWidth - 32),
      ],
    );
  }

  Widget _buildSingleColumnLayout(double screenWidth) {
    final sectionWidth = screenWidth - 32;
    
    return Column(
      children: [
        _buildConsignorSection(sectionWidth),
        const SizedBox(height: 16),
        _buildConsigneeSection(sectionWidth),
        const SizedBox(height: 16),
        _buildShipmentSection(sectionWidth),
        const SizedBox(height: 16),
        _buildPackageSection(sectionWidth),
        const SizedBox(height: 16),
        _buildAWBFinancialSection(sectionWidth),
      ],
    );
  }

  Widget _buildConsignorSection(double width) {
    return _buildSection(
      title: 'Consignor Details',
      width: width,
      children: [
        _buildFormField('Consignor Name', 'consignorName'),
        _buildPhoneFormField('Consignor Phone', 'consignorPhone', 'consignor', _isConsignorContactFound),
        _buildTextAreaField('Consignor Address', 'consignorAddress'),
        _buildFormField('Consignor GSTIN', 'consignorGSTIN', isOptional: true),
        _buildFormField('Consignor Email', 'consignorEmail', isOptional: true),
      ],
    );
  }

  Widget _buildConsigneeSection(double width) {
    return _buildSection(
      title: 'Consignee Details',
      width: width,
      children: [
        _buildFormField('Consignee Name', 'consigneeName'),
        _buildPhoneFormField('Consignee Phone', 'consigneePhone', 'consignee', _isConsigneeContactFound),
        _buildTextAreaField('Consignee Address', 'consigneeAddress'),
        _buildFormField('Consignee GSTIN', 'consigneeGSTIN', isOptional: true),
        _buildFormField('Consignee Email', 'consigneeEmail', isOptional: true),
      ],
    );
  }

  Widget _buildShipmentSection(double width) {
    return _buildSection(
      title: 'Shipment Details',
      width: width,
      children: [
        _buildFormField('Origin', 'origin'),
        _buildFormField('Destination', 'destination'),
        _buildFormField('Type', 'type'),
        _buildDropdownField('Product', _selectedProduct, _productOptions, (value) {
          setState(() {
            _selectedProduct = value;
          });
        }),
      ],
    );
  }

  Widget _buildPackageSection(double width) {
    return _buildSection(
      title: 'Package Details (Optional)',
      width: width,
      children: [
        // Use a 2-column grid for package details
        Row(
          children: [
            Expanded(child: _buildTextAreaField('Content Specification', 'contentSpecification', isOptional: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextAreaField('Paperwork Enclosed', 'paperworkEnclosed', isOptional: true)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildFormField('Declared Value', 'declaredValue', isNumber: true, isOptional: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildFormField('Number of Pieces', 'numberOfPieces', isNumber: true, isOptional: true)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildFormField('Actual Weight (gms)', 'actualWeight', isNumber: true, isOptional: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildFormField('Ewaybill Number', 'ewaybillNumber', isOptional: true)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildFormField('Dimensions (LxWxH)', 'dimensions', isOptional: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildFormField('Charged Weight (gms)', 'chargedWeight', isNumber: true, isOptional: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildAWBFinancialSection(double width) {
    return _buildSection(
      title: 'AWB & Financial Details',
      width: width,
      children: [
        _buildFormField('AWB Number', 'awbNumber'),
        _buildFormField('Risk Surcharge', 'riskSurcharge', isNumber: true, isOptional: true),
        _buildFormField('Total Amount', 'totalAmount', isNumber: true),
        _buildDropdownField('Mode of Payment', _selectedModeOfPayment, _modeOfPaymentOptions, (value) {
          setState(() {
            _selectedModeOfPayment = value;
          });
        }),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16), // Reduced from 24
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F7FC),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF528198)),
          borderRadius: BorderRadius.circular(12), // Reduced from 20
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF5D6D7E)), // Reduced from 24
          ),
          const Divider(height: 16), // Reduced from 24
          ...children,
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String key, {bool isNumber = false, bool isOptional = false, String? Function(String?)? validator} ){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Reduced from 16
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: validator ?? (isOptional ? null : (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        }),
        style: const TextStyle(fontSize: 14), // Reduced font size
        decoration: InputDecoration(
          labelText: isOptional ? '$label (Optional)' : label,
          labelStyle: const TextStyle(fontSize: 13), // Smaller label
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Reduced border radius
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Reduced padding
          isDense: true, // Make field more compact
        ),
      ),
    );
  }

  Widget _buildTextAreaField(String label, String key, {bool isOptional = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _controllers[key],
        maxLines: 3, // Multi-line text area
        validator: validator ?? (isOptional ? null : (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        }),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: isOptional ? '$label (Optional)' : label,
          labelStyle: const TextStyle(fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
          alignLabelWithHint: true, // Align label with hint text for multi-line
        ),
      ),
    );
  }

  Widget _buildPhoneFormField(String label, String key, String contactType, bool isContactFound) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Reduced from 16
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: TextInputType.phone,
        onChanged: contactType == 'consignor' ? _onConsignorPhoneChanged : _onConsigneePhoneChanged,
        validator: phoneValidator,
        style: const TextStyle(fontSize: 14), // Reduced font size
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13), // Smaller label
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Reduced border radius
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Reduced padding
          isDense: true, // Make field more compact
          suffixIcon: isContactFound 
            ? const Icon(Icons.contact_phone, color: Colors.green, size: 20) // Smaller icon
            : const Icon(Icons.phone, color: Colors.grey, size: 20), // Smaller icon
          helperText: isContactFound ? 'Contact found and details filled' : 'Enter 10-digit phone number',
          helperStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 11, // Reduced helper text size
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Reduced from 16
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        style: const TextStyle(fontSize: 14, color: Colors.black), // Reduced font size
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13), // Smaller label
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), // Reduced border radius
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Reduced padding
          isDense: true, // Make field more compact
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option, style: const TextStyle(fontSize: 14)), // Consistent font size
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }
}
