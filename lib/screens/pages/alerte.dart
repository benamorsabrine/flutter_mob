import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:todo/screens/config/config_service.dart';

class AlerteScreen extends StatefulWidget {
  final String token;

  AlerteScreen({required this.token});

  @override
  _AlerteScreenState createState() => _AlerteScreenState();
}

class _AlerteScreenState extends State<AlerteScreen> {
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
        Uri.parse('$address:$port/api/alert/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null) {
          setState(() {
            alerts = responseData;
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
                          title: Text(alert['message']),
                          subtitle: Text('Created At: $formattedDate'),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
