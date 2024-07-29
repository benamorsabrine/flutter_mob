import 'package:flutter/material.dart';

class EquipmentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> equipment;

  EquipmentDetailScreen({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equipements Details',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SN: ${equipment['equipement_sn']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Model: ${equipment['modele']}'),
            Text('Type: ${equipment['equipement_type']}'),
            Text('Status: ${equipment['status']}'),
            Text('Client: ${equipment['client'][0]['client']}'),
            Text('Service No: ${equipment['service'][0]['service_no']}'),
            Text('Contract SN: ${equipment['contrat'][0]['contrat_sn']}'),
            Text('Created At: ${equipment['createdAt']}'),
          ],
        ),
      ),
    );
  }
}
