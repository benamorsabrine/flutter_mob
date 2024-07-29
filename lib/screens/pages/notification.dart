import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';
import 'package:todo/screens/config/config_service.dart';

class NotificationScreen extends StatefulWidget {
  final String token;

  NotificationScreen({required this.token});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
        Uri.parse('$address:$port/api/notification/get'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null && responseData['notifications'] != null) {
          setState(() {
            alerts = responseData['notifications'];
            isLoading = false;
          });
        } else {
          throw Exception(
              'Response data is null or notifications key is missing');
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

  Future<void> deleteAlert(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$address:$port/api/notification/delete/$id'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          alerts.removeWhere((alert) => alert['_id'] == id);
        });
      } else {
        throw Exception('Failed to delete alert: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting alert: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
              ? Center(child: Text('No notification found'))
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
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteAlert(alert['_id']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
