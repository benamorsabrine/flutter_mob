import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:todo/screens/config/config_service.dart';

class AlerteCoordinatriceScreen extends StatefulWidget {
  final String token;

  AlerteCoordinatriceScreen({required this.token});

  @override
  _AlerteCoordinatriceScreenState createState() =>
      _AlerteCoordinatriceScreenState();
}

class _AlerteCoordinatriceScreenState extends State<AlerteCoordinatriceScreen> {
  List<dynamic> alerts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAlertes();
  }

    var address = ConfigService().adresse;
    var port = ConfigService().port;
  Future<void> fetchAlertes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$address:$port/api/alerts/get'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['alerts'] != null) {
          // Check if 'alerts' key exists
          setState(() {
            alerts = responseData['alerts']; // Access 'alerts' array
            isLoading = false;
          });
        } else {
          throw Exception('No alerts found');
        }
      } else {
        throw Exception('Failed to load alerts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching alerts: $error');
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
          'Alertes',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchAlertes,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : alerts.isEmpty
              ? Center(child: Text('No alerts found'))
              : RefreshIndicator(
                  onRefresh: fetchAlertes,
                  child: ListView.builder(
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      final DateTime createdAt =
                          DateTime.parse(alert['createdAt']);
                      final String formattedDate =
                          Jiffy(createdAt.toIso8601String()).yMMMMEEEEdjm;

                      return Card(
                          child: ListTile(
                              leading: Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${alert['userId']['firstname']} ${alert['userId']['lastname']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      'Reference Ticket: ${alert['ticketId']['reference']}'),
                                  Text(
                                      'Localisation: ${alert['ticketId']['service_station']}'),
                                  Text('Alert: ${alert['message']}'),
                                  Text('Created At: $formattedDate'),
                                ],
                              )));
                    },
                  ),
                ),
    );
  }
}
