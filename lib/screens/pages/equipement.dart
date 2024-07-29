import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/pages/equipementDetails.dart';
import 'package:todo/screens/config/config_service.dart';

class EquipementScreen extends StatefulWidget {
  @override
  _EquipementScreenState createState() => _EquipementScreenState();
}

class _EquipementScreenState extends State<EquipementScreen> {
  List<dynamic> equipements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEquipements();
  }
    var address = ConfigService().adresse;
    var port = ConfigService().port;
  Future<void> fetchEquipements() async {
    try {
      final response =
          await http.get(Uri.parse('$address:$port/api/equi/list'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null) {
          setState(() {
            equipements = responseData;
            isLoading = false;
          });
        } else {
          throw Exception('Response data is null');
        }
      } else {
        throw Exception('Failed to load equipements: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching equipements: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equipements',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      body:Padding(
        padding: const EdgeInsets.only(top: 5.0),  
        child: isLoading
      
          ? Center(child: CircularProgressIndicator())
          : equipements.isEmpty
              ? Center(child: Text('No equipements found'))
              : ListView.builder(
                  itemCount: equipements.length,
                  itemBuilder: (context, index) {
                    final equipement = equipements[index];
                    return Card(
                      child: ListTile(
                        title: Text('SN: ${equipement['equipement_sn']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EquipmentDetailScreen(equipment: equipement),
                            ),
                          );
                        },
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Model: ${equipement['modele']}'),
                            Text('Type: ${equipement['equipement_type']}'),
                           
                          ],
                        ),
                      ),
                    );
                  },
                ),
    ));
  }
}
