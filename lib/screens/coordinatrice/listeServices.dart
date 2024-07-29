import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:todo/screens/config/config_service.dart';

class ListeServiceScreen extends StatefulWidget {
  final String token;

  ListeServiceScreen({required this.token});

  @override
  _ListeServiceScreenScreenState createState() =>
      _ListeServiceScreenScreenState();
}

class _ListeServiceScreenScreenState extends State<ListeServiceScreen> {
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

    var address = ConfigService().adresse;
    var port = ConfigService().port;
  Future<void> fetchServices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$address:$port/api/service/liste'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null) {
          setState(() {
            services = responseData;
            isLoading = false;
          });
        } else {
          throw Exception('Response data is null');
        }
      } else {
        throw Exception('Failed to load services: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching services: $error');
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
          'Services',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchServices,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : services.isEmpty
              ? Center(child: Text('No services found'))
              : ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Container(
                      color: (() {
                        final terminationDate =
                            service['termination_date'] ?? null;
                        final currentDate = DateTime.now();
                        final halfYearInMonths = 6;
                        final monthsDifference = terminationDate != null
                            ? currentDate
                                .difference(DateTime.parse(terminationDate))
                                .inDays
                            : null;
                        if (monthsDifference != null) {
                          if (monthsDifference > halfYearInMonths) {
                            return Color(0xFF77dd77); // green color
                          } else if (monthsDifference <= 0) {
                            return Colors.red;
                          } else {
                            return Colors.orange;
                          }
                        }
                        return Colors.transparent;
                      })(),
                      child: ListTile(
                        title: Text(service['service_no'] ?? 'N/A'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Contract: ${service['contrat'].isNotEmpty ? service['contrat'][0]['contrat_sn'] : 'N/A'}'),
                            Text('Model: ${service['model']}'),
                            Text('Quantity: ${service['quantity']}'),
                            Text(
                                'Effective Date: ${Jiffy(service['effective_date']).format('yyyy/MM/dd') ?? 'N/A'}'),
                            Text(
                                'Termination Date: ${Jiffy(service['termination_date']).format('yyyy/MM/dd') ?? 'N/A'}'),
                            Text(
                                'Created At: ${Jiffy(service['createdAt']).format('yyyy/MM/dd HH:mm') ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
