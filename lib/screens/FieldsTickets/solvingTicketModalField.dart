import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:todo/screens/FieldsTickets/qrCodeScreenFin.dart';
import 'package:todo/screens/FieldsTickets/SolvedFieldTicket.dart';

class SimpleHelloDialogField extends StatefulWidget {
  final String ticketId;
  final String token;

  SimpleHelloDialogField(
      {Key? key, required this.ticketId, required this.token})
      : super(key: key);

  @override
  _SimpleHelloDialogFieldState createState() => _SimpleHelloDialogFieldState();
}

class _SimpleHelloDialogFieldState extends State<SimpleHelloDialogField> {
  final TextEditingController solutionController = TextEditingController();
  bool isImageUploaded = false;
  String? imageBase64;
  String? qrResult;
  String errorMessage = '';
  String solutionError = '';
  String imageError = '';
  String qrCodeError = '';

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final imageBytes = await file.readAsBytes();
    imageBase64 = base64Encode(imageBytes);

    setState(() {
      isImageUploaded = true;
      imageError = '';
    });

    print('Image uploaded successfully');
  }

  void validateFields() {
    setState(() {
      solutionError = solutionController.text.isEmpty
          ? 'Veuillez entrer une solution.'
          : '';
      imageError = imageBase64 == null || imageBase64!.isEmpty
          ? 'Veuillez ajouter l\'image de la fiche d\'intervention.'
          : '';
      qrCodeError = qrResult == null || qrResult!.isEmpty
          ? 'Veuillez introduire le code QR.'
          : '';
      errorMessage = '';
    });
  }

  Future<void> handleSolved(BuildContext context) async {
    // Effectuer la mise à jour du ticket
    try {
      // Obtenir les détails du ticket
      final ticketResponse = await http.get(
        Uri.parse('http://192.168.93.54:4000/api/ticket/${widget.ticketId}'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (ticketResponse.statusCode != 200) {
        throw Exception('Failed to fetch ticket details');
      }

      final ticketData = json.decode(ticketResponse.body);
      final codeqrStart = ticketData['codeqrStart'];

      if (codeqrStart != qrResult) {
        showErrorDialog(context, message: 'Code QR incorrect');
        return;
      }

      // Mettre à jour le ticket si les codes QR correspondent
      final updateResponse = await http.put(
        Uri.parse(
            'http://192.168.93.54:4000/api/ticket/updateTicketSolve/${widget.ticketId}'), // Inclure le ticketId dans l'URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
        body: json.encode({
          'ticketId': widget.ticketId,
          'codeqrEnd': qrResult,
          'solving_time': DateTime.now().toIso8601String(),
          'solution': solutionController.text,
          'image': imageBase64,
        }),
      );

      if (updateResponse.statusCode == 200) {
        Navigator.of(context).pop(); // Fermer le dialogue
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FieldSolvedScreen(token: widget.token),
          ),
        );
        // Retourner à l'écran précédent
        /*    Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FieldSolvedScreen(
            token: '',
          ), // Assurez-vous que cette page existe
        )); */
      } else {
        throw Exception('Failed to update ticket');
      }
    } catch (error) {
      showErrorDialog(context);
    }
  }

  void showErrorDialog(BuildContext context,
      {String message = "Une erreur s'est produite. Veuillez réessayer."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> submit() async {
    validateFields();

    if (solutionError.isNotEmpty ||
        imageError.isNotEmpty ||
        qrCodeError.isNotEmpty) {
      return; // Ne pas appeler handleSolved si des champs sont invalides
    }

    await handleSolved(
        context); // Appeler handleSolved seulement si les champs sont valides
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Solving Ticket'),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: 300,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Solution:'),
              TextField(
                controller: solutionController,
                decoration: InputDecoration(
                  hintText: 'Entrez la solution',
                ),
              ),
              SizedBox(height: 16),
              if (solutionError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    solutionError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (imageError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    imageError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (qrCodeError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    qrCodeError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 176, 190, 173),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Upload Image', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  qrResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScannerScreenFin(),
                    ),
                  );
                  if (qrResult != null) {
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 176, 190, 173),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Scan QR Code', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: submit, // Appeler la fonction submit
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
