import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo/screens/config/config_service.dart';

class ListeClientScreen extends StatefulWidget {
  final String token;

  ListeClientScreen({required this.token});

  @override
  _ListeClientScreenScreenState createState() =>
      _ListeClientScreenScreenState();
}

class _ListeClientScreenScreenState extends State<ListeClientScreen> {
  List<dynamic> clients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

    var address = ConfigService().adresse;
    var port = ConfigService().port;
  Future<void> fetchClients() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$address:$port/api/client/list'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null) {
          setState(() {
            clients = responseData;
            isLoading = false;
          });
        } else {
          throw Exception('Response data is null');
        }
      } else {
        throw Exception('Failed to load alertes: ${response.statusCode}');
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
          'Clients',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchClients,
          ),
        ],
      ),
     body: isLoading
          ? Center(child: CircularProgressIndicator())
          : clients.isEmpty
              ? Center(child: Text('No clients found'))
              : RefreshIndicator(
                  onRefresh: fetchClients, // Call fetchClients instead of fetchAlertes
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      final client = clients[index]; // Fetch individual client
                      return Card(
                        child: ListTile(
                          title: Text(client['client']), // Access client data fields
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Address: ${client['adresse']}'),
                              Text('Email: ${client['email']}'),
                              Text('Corporate: ${client['corporate']}'),
                              Text('Office: ${client['office']}'),
                              Text('Mobile: ${client['mobile']}'),
                            ],
                          ),
                          
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}