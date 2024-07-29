import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerScreenFin extends StatefulWidget {
  @override
  _QrScannerScreenFinState createState() => _QrScannerScreenFinState();
}

class _QrScannerScreenFinState extends State<QrScannerScreenFin> {
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
                  ? Text('Scanned Code: ${result!.code}', style: TextStyle(fontSize: 20))
                  : Text('Scan a code', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    if (_isCameraInitialized) {
      return;
    }

    this.controller = controller;
    _isCameraInitialized = true;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      _timer?.cancel();
      _timer = Timer(Duration(seconds: 1), () {
        controller.dispose();
        Navigator.pop(context, result!.code);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }
}
