import 'package:flutter/material.dart';
import 'package:todo/screens/coordinatrice/listeClients.dart';
import 'package:todo/screens/coordinatrice/listeContrats.dart';
import 'package:todo/screens/coordinatrice/listeServices.dart';
import 'package:todo/screens/pages/main_home.dart';
import 'package:todo/screens/pages/notification.dart';
import 'package:todo/screens/pages/profile.dart';
import 'package:todo/screens/tickets/phoneTicket.dart';



class Clientmanagement extends StatefulWidget {
  final String token;
  final String email;
  const Clientmanagement({super.key, required this.token, required this.email});

  @override
  State<Clientmanagement> createState() => _ClientmanagementScreenState();
}

class _ClientmanagementScreenState extends State<Clientmanagement> {
  late final userId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.token);
    print(widget.email);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(token: widget.token),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FieldTicket(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PTicketScreen(token: widget.token),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              token: widget.token,
              email: widget.email,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Management',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          const SizedBox(height: 160),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListeClientScreen(
                          token: widget.token,
                          //email: email,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 118, 118),
                  minimumSize: Size(150, 160),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Clients',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ListeContratScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 28, 130, 255),
                  minimumSize: Size(150, 160),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pages, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Contrats',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ListeServiceScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 91, 142, 2),
                  minimumSize: Size(150, 160),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.room_service, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Services',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Field Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Phone Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 255, 70, 104),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
