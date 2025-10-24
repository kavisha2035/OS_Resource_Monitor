// lib/services/pdf_receipt_service.dart
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Import your Hive-based model
import '../models/consignment_model.dart';

class PdfReceiptService {
  Future<void> generateAndPrintReceipt(Consignment consignment) async {
    final doc = pw.Document();

    // Load fonts
    final font = await PdfGoogleFonts.anekLatinRegular();
    final boldFont = await PdfGoogleFonts.anekLatinBold();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(15),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              _buildHeader(consignment),
              _buildConsignorConsigneeSection(consignment),
              pw.Expanded(child: _buildMainContentSection(consignment)),
              _buildFooterSection(consignment),
              _buildBottomLine(),
            ],
          );
        },
      ),
    );

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    } catch (e) {
      debugPrint("Error printing PDF: $e");
    }
  }

  pw.Widget _buildBorderedCell(
    String text, {
    pw.EdgeInsets padding = const pw.EdgeInsets.all(8),
    pw.Alignment alignment = pw.Alignment.centerLeft,
    pw.TextStyle? style,
  }) {
    return pw.Container(
      width: double.infinity,
      height: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: padding,
      alignment: alignment,
      child: pw.Text(text, style: style),
    );
  }

  pw.Widget _buildHeader(Consignment consignment) {
    return pw.SizedBox(
      height: 100,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Movers Express Limited',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Regd. Office No. 3, Victoria Road\nBengaluru - 560047',
                  ),
                ],
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    children: [
                      pw.Expanded(
                        child: _buildBorderedCell(
                          'Origin: ${consignment.Origin}',
                        ),
                      ),
                      pw.Expanded(
                        child: _buildBorderedCell(
                          'Product: ${consignment.Product}',
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    children: [
                      pw.Expanded(
                        child: _buildBorderedCell(
                          'Dest: ${consignment.Destination}',
                        ),
                      ),
                      pw.Expanded(child: _buildBorderedCell('Type: DOCUMENT')),
                      pw.Expanded(
                        child: _buildBorderedCell(
                          'Date: ${DateFormat('E MMM dd yyyy').format(consignment.Date)}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildConsignorConsigneeSection(Consignment consignment) {
    return pw.SizedBox(
      height: 80,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Expanded(
            child: pw.Container(
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              padding: const pw.EdgeInsets.all(5),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text('Consignor\'s Name: ${consignment.ConsignorName}'),
                  pw.Text(
                    'Consignor\'s Address: ${consignment.ConsignorAddress}',
                  ),
                  pw.Text('GSTIN No.: ${consignment.ConsignorGSTIN}'),
                  pw.Text(
                    'Phone: ${consignment.ConsignorPhone} Email: ${consignment.ConsignorEmail}',
                  ),
                ],
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              padding: const pw.EdgeInsets.all(5),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text('Customer Ref No.:'),
                  pw.Text('Consignee\'s Name: ${consignment.ConsigneeName}'),
                  pw.Text(
                    'Consignee\'s Address: ${consignment.ConsigneeAddress}',
                  ),
                  pw.Text('GSTIN No.: ${consignment.ConsigneeGSTIN}'),
                  pw.Text(
                    'Phone: ${consignment.ConsigneePhone} Email: ${consignment.ConsigneeEmail}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMainContentSection(Consignment consignment) {
    final declaredValueText = consignment.DeclaredValue == 0
        ? 'Not Applicable'
        : consignment.DeclaredValue.toStringAsFixed(2);
    final piecesText = consignment.NumberOfPieces == 0
        ? 'Not Applicable'
        : consignment.NumberOfPieces.toString();

    var column = pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.BarcodeWidget(
          barcode: pw.Barcode.code128(),
          data: consignment.AWBNumber,
          width: 250,
          height: 60,
        ),
        pw.SizedBox(height: 8),
        pw.Text('AWB No: ${consignment.AWBNumber}'),
      ],
    );

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.SizedBox(
                height: 70,
                child: _buildBorderedCell(
                  'Content Specification:\n\nPaperwork Enclosed:',
                ),
              ),
              pw.Expanded(
                child: _buildBorderedCell(
                  'I/We declare that this consignment does not contain personal mail, cash, jewellery, contraband, illegal drugs, any prohibited items and commodities which can cause safety hazards while transporting.\n\nSender\'s Signature & Seal\nI have read and understood terms & conditions of carriage mentioned on website www.dtdc.in, and I agree to the same.',
                  alignment: pw.Alignment.topLeft,
                  padding: const pw.EdgeInsets.all(4),
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            children: [
              pw.SizedBox(
                height: 30,
                child: _buildBorderedCell('Declared Value: $declaredValueText'),
              ),
              pw.SizedBox(
                height: 30,
                child: _buildBorderedCell('No Of Pieces: $piecesText'),
              ),
              pw.SizedBox(
                height: 30,
                child: _buildBorderedCell(
                  'Actual Weight: ${consignment.ActualWeight.toStringAsFixed(2)} Gms',
                ),
              ),
              pw.SizedBox(
                height: 30,
                child: _buildBorderedCell(
                  'Ewaybill Number: ${consignment.EwaybillNumber}',
                ),
              ),
              pw.SizedBox(
                height: 30,
                child: _buildBorderedCell('Dim: ${consignment.Dimensions}'),
              ),
              pw.SizedBox(
                height: 30,
                child: _buildBorderedCell(
                  'Charged weight: ${consignment.ChargedWeight.toStringAsFixed(2)} Gms',
                ),
              ),
              pw.Expanded(
                child: _buildBorderedCell(
                  'Name: ${consignment.CenterName}\nAddress: ${consignment.CenterAddress}\nPhone: ${consignment.CenterPhone}',
                  alignment: pw.Alignment.topLeft,
                  padding: const pw.EdgeInsets.all(4),
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: column,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Expanded(
                      child: _buildBorderedCell(
                        'Risk Surcharge',
                        alignment: pw.Alignment.center,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          pw.Expanded(
                            child: _buildBorderedCell(
                              'Owner',
                              alignment: pw.Alignment.centerLeft,
                            ),
                          ),
                          pw.Expanded(
                            child: _buildBorderedCell(
                              'Carrier',
                              alignment: pw.Alignment.centerLeft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooterSection(Consignment consignment) {
    return pw.SizedBox(
      height: 35,
      child: pw.Row(
        children: [
          _buildFooterCell('https://www.movers.in', 1, isUrl: true),
          _buildFooterCell('customersupport@movers.com', 1),
          _buildFooterCell('+91-9606911811', 1),
          _buildFooterCell(
            'Amount collected (in Rs.): ${consignment.TotalAmount.toStringAsFixed(2)}',
            2,
          ),
          _buildFooterCell('Payment Mode: ${consignment.ModeOfPayment}', 1),
        ],
      ),
    );
  }

  pw.Widget _buildFooterCell(String text, int flex_val, {bool isUrl = false}) {
    return pw.Expanded(
      flex: flex_val,
      child: _buildBorderedCell(
        text,
        alignment: pw.Alignment.center,
        style: pw.TextStyle(
          fontSize: 9,
          decoration: isUrl ? pw.TextDecoration.underline : null,
          color: isUrl ? PdfColors.blue : PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _buildBottomLine() {
    return pw.SizedBox(
      height: 35,
      child: pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        padding: const pw.EdgeInsets.symmetric(horizontal: 8),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'THIS DOCUMENT IS NOT A TAX INVOICE. WEIGHT CAPTURED BY DTDC WILL BE USED FOR INVOICE GENERATION.',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.Text(
              'POD Copy',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
