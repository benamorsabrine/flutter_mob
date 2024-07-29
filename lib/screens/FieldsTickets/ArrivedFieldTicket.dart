import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/FieldsTickets/LoadingFieldTicket.dart';
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

  ///////////////////////////////// START//////////////////////////////////
  Future<void> handleStartTicket(BuildContext context, String ticketId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Êtes-vous sûr de vouloir commencer ce ticket ?'),
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
              child: Text('Oui, commencer'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final qrResult = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QrScannerScreen()),
      );

      if (qrResult != null && qrResult.isNotEmpty) {
        print('Scanned QR Code: $qrResult'); // Impression de débogage

        try {
          final response = await http.get(
            Uri.parse('http://192.168.93.54:4000/api/ticket/$ticketId'),
            headers: {'Authorization': 'Bearer ${widget.token}'},
          );

          if (response.statusCode == 200) {
            final ticketData = json.decode(response.body);
            final String codeqrequipement =
                ticketData['codeqrequipement'] ?? '';

            print(
                'Equipment QR Code: $codeqrequipement'); // Impression de débogage

            if (codeqrequipement.isEmpty) {
              final updateResponse = await http.put(
                Uri.parse(
                    'http://192.168.93.54:4000/api/ticket/started/$ticketId'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${widget.token}'
                },
                body: json.encode({
                  'status': 'LOADING',
                  'codeqrStart': qrResult,
                  'codeqrequipement': qrResult,
                  'starting_time': DateTime.now().toIso8601String(),
                }),
              );

              if (updateResponse.statusCode == 200) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Ticket commencé avec succès!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            fetchAssignedTickets();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showErrorDialog(context);
              }
            } else {
              if (codeqrequipement.isNotEmpty && codeqrequipement == qrResult) {
                final updateResponse = await http.put(
                  Uri.parse(
                      'http://192.168.93.54:4000/api/ticket/started/$ticketId'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${widget.token}'
                  },
                  body: json.encode({
                    'status': 'LOADING',
                    'codeqrStart': qrResult,
                    'starting_time': DateTime.now().toIso8601String(),
                  }),
                );

                if (updateResponse.statusCode == 200) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Ticket commencé avec succès!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FieldLoadingScreen(
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
                  showErrorDialog(context);
                }
              } else {
                print(
                    'QR Code mismatch: $qrResult != $codeqrequipement'); // Impression de débogage
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Erreur'),
                      content: Text(
                          'Le code QR scanné ne correspond pas au code QR de l\'équipement. $qrResult != $codeqrequipement'),
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
          } else {
            showErrorDialog(context);
          }
        } catch (error) {
          showErrorDialog(context);
        }
      } else {
        showErrorDialog(context,
            message: "Scan de QR code annulé ou invalide.");
      }
    } else {
      print("La valeur n'a pas été passée vers cette interface.");
    }
  }

  void showErrorDialog(BuildContext context,
      {String message = "Veuillez réessayer plus tard"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text(message),
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

  /*
 Future<void> handleStartTicket(String ticketId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Êtes-vous sûr de vouloir commencer ce ticket ?'),
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
              child: Text('Oui, commencer'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        final response = await http.put(
          Uri.parse('$url:$port/api/ticket/started/$ticketId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'status': 'LOADING'}),
        );
        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Ticket commencé avec succès!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      fetchAssignedTickets();
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
  }*/
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
                        trailing: ElevatedButton(
                          onPressed: () {
                            //handleStartTicket(tickets[index]['_id']);
                            handleStartTicket(context, tickets[index]['_id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 51, 197, 66),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Start',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
