import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:todo/screens/config/config_service.dart';

class ListeContratScreen extends StatefulWidget {
  final String token;

  ListeContratScreen({required this.token});

  @override
  _ListeContratScreenScreenState createState() =>
      _ListeContratScreenScreenState();
}

class _ListeContratScreenScreenState extends State<ListeContratScreen> {
  List<dynamic> contrats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContrats();
  }

    var address = ConfigService().adresse;
    var port = ConfigService().port;
  Future<void> fetchContrats() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$address:$port/api/contrat/liste'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null) {
          setState(() {
            contrats = responseData;
            isLoading = false;
          });
        } else {
          throw Exception('Response data is null');
        }
      } else {
        throw Exception('Failed to load contracts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching contracts: $error');
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
          'Contrats',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchContrats,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contrats.isEmpty
              ? Center(child: Text('No contracts found'))
              : RefreshIndicator(
                  onRefresh: fetchContrats,
                  child: ListView.builder(
                    itemCount: contrats.length,
                    itemBuilder: (context, index) {
                      final contrat = contrats[index];
                      return Column(
                        children: [
                          ListTile(
                            tileColor: (() {
                              final terminationDate =
                                  contrat['termination_date'] ?? null;
                              final currentDate = DateTime.now();
                              final halfYearInMonths = 6;
                              final monthsDifference = terminationDate != null
                                  ? currentDate
                                      .difference(
                                          DateTime.parse(terminationDate))
                                      .inDays
                                  : null;

                              if (monthsDifference != null) {
                                if (monthsDifference > halfYearInMonths) {
                                  return Colors
                                      .green; // Change color as per condition
                                } else if (monthsDifference <= 0) {
                                  return Colors.red;
                                } else {
                                  return Colors.orange;
                                }
                              }
                              return Colors.transparent;
                            })(),
                            title: Text(
                              contrat['contrat_sn'] ?? 'N/A',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Client: ${contrat['client'][0]['client'] ?? 'N/A'}'),
                                Text(
                                    'Effective Date: ${Jiffy(contrat['effective_date']).format('yyyy/MM/dd') ?? 'N/A'}'),
                                Text(
                                    'Termination Date: ${Jiffy(contrat['termination_date']).format('yyyy/MM/dd') ?? 'N/A'}'),
                                Text(
                                    'Created At: ${Jiffy(contrat['createdAt']).format('yyyy/MM/dd HH:mm') ?? 'N/A'}'),
                              ],
                            ),
                          ),
                          SizedBox(height: 8), // Add space between contracts
                        ],
                      );
                    },
                  ),
                ),
    );
  }
}
