import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/FieldsTickets/qrCodeScreen.dart';
import 'dart:convert';
import 'package:todo/screens/config/config_service.dart';
import 'package:todo/screens/tickets/ticketDetails.dart';

class FieldArrivedScreen extends StatefulWidget {
  final String token;
  final String? email;

  const FieldArrivedScreen({Key? key, required this.token, this.email})
      : super(key: key);

  @override
  _FieldArrivedScreenState createState() => _FieldArrivedScreenState();
}

class _FieldArrivedScreenState extends State<FieldArrivedScreen> {
  bool isLoading = false;
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchAssignedTickets();
  }

  var address = ConfigService().adresse;
  var port = ConfigService().port;
  Future<void> fetchAssignedTickets() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$address:$port/api/ticket/field'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null) {
          setState(() {
            tickets = responseData
                .where((ticket) => ticket['status'] == 'ARRIVED')
                .toList();
            isLoading = false;
          });
        } else {
          throw Exception('Response data is null');
        }
      } else {
        throw Exception('Failed to load tickets: ${response.statusCode}');
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
          'Arrived',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchAssignedTickets,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? Center(
                  child: Text(
                    'No arrived tickets found.',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    var ticket = tickets[index];
                    var technicien = ticket['technicien'];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(tickets[index]['reference']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TicketDetailScreen(ticket: tickets[index]),
                            ),
                          );
                        },
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tickets[index]['status']),
                            Text(tickets[index]['service_station']),
                            if (technicien != null)
                              Text(
                                '${technicien['firstname'] ?? ''} ${technicien['lastname'] ?? ''}',
                              )
                            else
                              Text('N/A'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
