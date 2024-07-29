import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/FieldsTickets/EnRouteFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/ReportedFieldTicket.dart';
import 'dart:convert';
import 'package:todo/screens/config/config_service.dart';
import 'package:todo/screens/tickets/ticketDetails.dart';

class FieldAcceptedScreen extends StatefulWidget {
  final String token;
  final String? email;

  const FieldAcceptedScreen({Key? key, required this.token, this.email})
      : super(key: key);

  @override
  _FieldAcceptedScreenState createState() => _FieldAcceptedScreenState();
}

class _FieldAcceptedScreenState extends State<FieldAcceptedScreen> {
  bool isLoading = false;
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchAssignedTickets();
  }

  // var address = ConfigService().adresse;
  // var port = ConfigService().port;
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
                .where((ticket) => ticket['status'] == 'ACCEPTED')
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

  Future<void> handleReportTicket(String ticketId) async {
    String reporting_note_assigned =
        ''; // Variable pour stocker la raison du report

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
                  reporting_note_assigned =
                      value; // Met à jour la raison du report à chaque changement
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
                Navigator.of(context).pop(false); // Annule l'action de report
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (reporting_note_assigned.trim().isEmpty) {
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

                Navigator.of(context).pop(true); // Confirme l'action de report
                try {
                  final response = await http.put(
                    Uri.parse(
                        'http://192.168.93.54:4000/api/ticket/ReportingAssigned/$ticketId'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'status': 'REPORTED',
                      'reporting_note_assigned': reporting_note_assigned,
                      'reporting_assignedTicket_time':
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
                                Navigator.of(context)
                                    .pop(); // Fermer le dialogue
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FieldReportedScreen(
                                      token: '',
                                    ),
                                  ), // Naviguer vers FieldReportedScreen
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

  Future<void> handleAcceptTicket(String ticketId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Êtes-vous sûr  de partir ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Oui, je vais partir'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        final response = await http.put(
          Uri.parse('http://192.168.93.54:4000/api/ticket/depart/$ticketId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'status': 'LEFT',
            'departure_time': DateTime.now().toIso8601String(),
          }),
        );

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Partis avec succès!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FieldEnRouteScreen(
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Erreur ticket"),
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
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erreur "),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accepted',
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
                    'No assigned tickets found.',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10), // Add padding to Card
                        child: Column(
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
                            SizedBox(
                                height:
                                    10), // Add spacing between text and buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      handleAcceptTicket(tickets[index]['_id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 248, 35),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Depart',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 42, 42, 42)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 10), // Add spacing between buttons
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      handleReportTicket(tickets[index]['_id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 97, 5, 184),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Report',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
