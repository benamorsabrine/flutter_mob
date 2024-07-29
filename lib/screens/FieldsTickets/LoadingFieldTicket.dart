import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/FieldsTickets/ReportedFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/solvingTicketModalField.dart';
import 'package:todo/screens/tickets/ticketDetails.dart';
import 'package:todo/screens/config/config_service.dart';
// import 'simple_hello_dialog_field.dart'; // Assurez-vous d'importer le bon fichier

class FieldLoadingScreen extends StatefulWidget {
  final String token;
  final String? email;

  const FieldLoadingScreen({Key? key, required this.token, this.email})
      : super(key: key);

  @override
  _FieldLoadingScreenState createState() => _FieldLoadingScreenState();
}

class _FieldLoadingScreenState extends State<FieldLoadingScreen> {
  bool isLoading = false;
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchAssignedTickets();
  }

  Future<void> fetchAssignedTickets() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('http://192.168.93.54:4000/api/ticketht/assigned/field'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null) {
          setState(() {
            tickets = responseData
                .where((ticket) => ticket['status'] == 'LOADING')
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
      print('Error fetching tickets: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSimpleHelloDialog(
      BuildContext context, String ticketId, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleHelloDialogField(ticketId: ticketId, token: token);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading...',
            style: TextStyle(color: Colors.white, fontSize: 24)),
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
                  child: Text('No loading tickets found.',
                      style: TextStyle(fontSize: 20)))
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
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
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(tickets[index]['status']),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Agence: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(tickets[index]['service_station']),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                String ticketId = tickets[index]['_id'];
                                String token = widget.token;
                                showSimpleHelloDialog(context, ticketId, token);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 35, 171, 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Solved',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                handleReportTicket(tickets[index]['_id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 81, 81, 81),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Reported',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> handleReportTicket(String ticketId) async {
    String reporting_note_solve = '';

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reporting Ticket ?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Pourquoi voulez-vous reporter le ticket ?'),
              TextField(
                onChanged: (value) {
                  reporting_note_solve = value;
                },
                decoration: InputDecoration(
                  hintText: 'Raison du report',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (reporting_note_solve.trim().isEmpty) {
                  // Affiche un message d'erreur si le champ est vide
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Attention'),
                        content:
                            Text('Le champ de raison du report est requis.'),
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
                  return; // Arrête l'exécution si le champ est vide
                }

                Navigator.of(context).pop(true);
                try {
                  final response = await http.put(
                    Uri.parse(
                        'http://192.168.93.54:4000/api/ticket/ReportingSolve/$ticketId'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'status': 'REPORTED',
                      'reporting_note_solve': reporting_note_solve,
                      'reporting_SolvedTicket_time':
                          DateTime.now().toIso8601String(),
                    }),
                  );

                  if (response.statusCode == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Reporté avec succès!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FieldReportedScreen(
                                      token: widget.token,
                                    ),
                                  ),
                                );
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    throw Exception('Échec du report du ticket');
                  }
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Erreur lors du report"),
                        content: Text("Veuillez réessayer plus tard"),
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
              },
              child: Text('Reporter'),
            ),
          ],
        );
      },
    );
  }
}
