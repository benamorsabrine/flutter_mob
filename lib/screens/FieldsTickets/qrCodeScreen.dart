import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  Timer? _timer;
  bool _isCameraInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Scanned Code: ${result!.code}',
                      style: TextStyle(fontSize: 20))
                  : Text('Scan a code', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    if (_isCameraInitialized) {
      // Ne réinitialisez pas la caméra si elle est déjà initialisée
      return;
    }

    this.controller = controller;
    _isCameraInitialized = true;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      print('Scanned QR Code: ${result!.code}'); // Impression de débogage

      _timer?.cancel(); // Annuler tout timer existant
      _timer = Timer(Duration(seconds: 1), () {
        controller.dispose(); // Dispose de la caméra
        Navigator.pop(context, result!.code); // Renvoie le code scanné
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annuler le timer s'il est toujours en cours
    if (controller != null) {
      controller!.dispose(); // Dispose de la caméra
    }
    super.dispose();
  }
}
