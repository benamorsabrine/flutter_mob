import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class TicketDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ticket;

  TicketDetailScreen({required this.ticket});

  @override
  Widget build(BuildContext context) {
    String formatDate(String? date) {
      if (date == null) return 'Not yet';
      try {
        return DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(date));
      } catch (e) {
        return 'Invalid date';
      }
    }

    bool isApproved = ticket['status'] == 'APPROVED';

    /*
    Future<void> downloadPdf() async {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red, width: 2),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Tunisys',
                              style: pw.TextStyle(
                                  fontSize: 25,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.red)),
                          pw.Text('124, Avenue de la liberté'),
                          pw.Text('1002 Tunis-Bélvedére'),
                          pw.Text('Tél : 71 791 699'),
                          pw.Text('Fax : 71 786 188'),
                        ],
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.red, width: 8),
                        ),
                        child: pw.Text('Fiche Intervention',
                            style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.red)),
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Date :', style: pw.TextStyle(fontSize: 12)),
                          pw.Text(formatDate(ticket['completion_time']),
                              style: pw.TextStyle(fontSize: 15)),
                          pw.SizedBox(height: 10),
                          pw.Text('Numéro :',
                              style: pw.TextStyle(fontSize: 12)),
                          pw.Text(ticket['reference'] ?? "",
                              style: pw.TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red, width: 2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Client', style: pw.TextStyle(fontSize: 20)),
                      pw.Text(ticket['client']?['client'] ?? "",
                          style: pw.TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        padding: pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.red, width: 2),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Localisation',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                                ticket['service_station'] != null
                                    ? '${ticket['service_station'] ?? ''}'
                                    : '',
                                style: pw.TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.Container(
                        padding: pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.red, width: 2),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Num série',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                                ticket['equipement']?['equipement_sn'] ?? "",
                                style: pw.TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red, width: 2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Nature panne',
                          style: pw.TextStyle(fontSize: 20)),
                      pw.Text(ticket['service_type'] ?? "",
                          style: pw.TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red, width: 2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Heure', style: pw.TextStyle(fontSize: 20)),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('D\'arrivé',
                                  style: pw.TextStyle(fontSize: 18)),
                              pw.Text(formatDate(ticket['accepting_date']),
                                  style: pw.TextStyle(fontSize: 18)),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('De cloturage',
                                  style: pw.TextStyle(fontSize: 18)),
                              pw.Text(formatDate(ticket['solving_time']),
                                  style: pw.TextStyle(fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red, width: 2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Action envisagé',
                          style: pw.TextStyle(fontSize: 20)),
                      pw.Text(ticket['solution'] ?? "",
                          style: pw.TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red, width: 2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Visa', style: pw.TextStyle(fontSize: 20)),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: [
                          pw.Expanded(
                              child: pw.Container(
                                  height: 50,
                                  decoration: pw.BoxDecoration(
                                      border: pw.Border.all(
                                          color: PdfColors.black, width: 2)))),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                              child: pw.Container(
                                  height: 50,
                                  decoration: pw.BoxDecoration(
                                      border: pw.Border.all(
                                          color: PdfColors.black, width: 2)))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final fileName = 'ticket_${ticket['reference']}.pdf';
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$fileName';
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Open file in external application (platform-specific)
      if (Platform.isAndroid || Platform.isIOS) {
        await OpenFile.open(filePath);
      }
    }
    */

    // Décoder l'image de base64
    Uint8List? imageBytes;
    if (ticket['image'] != null && ticket['image'] is String) {
      try {
        imageBytes = base64Decode(ticket['image']);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Details',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Reference: ${ticket['reference'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Client: ${ticket['client']?['client'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Service Station: ${ticket['service_station'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text(
                'Equipment Serial Number: ${ticket['equipement']?['equipement_sn'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Service Type: ${ticket['service_type'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Accepting Date: ${formatDate(ticket['accepting_date'])}'),
            SizedBox(height: 10),
            Text('Solving Time: ${formatDate(ticket['solving_time'])}'),
            SizedBox(height: 10),
            Text('Solution: ${ticket['solution'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Status: ${isApproved ? 'Approved' : 'Not Approved'}'),
            SizedBox(height: 20),
            Text(
              'Photo Fiche Intervention',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (imageBytes != null && imageBytes.isNotEmpty) ...[
              Container(
                constraints: BoxConstraints(
                    maxHeight: 300), // Limite de hauteur pour l'image
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 0,
                      maxHeight: 300,
                    ),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit
                          .contain, // Redimensionner l'image pour la faire tenir dans le conteneur
                    ),
                  ),
                ),
              ),
            ] else ...[
              Text('No image available'),
            ],
            SizedBox(height: 20),
            // Afficher le bouton si le statut est 'APPROVED'
            if (isApproved)
              ElevatedButton(
                onPressed: () {
                  // Code pour télécharger le PDF ou autre action
                },
                child: Text('Download PDF'),
              ),
          ],
        ),
      ),
    );
  }
}
