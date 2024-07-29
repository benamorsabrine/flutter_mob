import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/auth/login_screen.dart';
import 'package:todo/screens/coordinatrice/FieldsTicketsCoordinatrice/FieldTickets.dart';
import 'package:todo/screens/coordinatrice/phoneTicketsCoordinatrice/phoneTicket.dart';
import 'package:todo/screens/coordinatrice/alerteCoordinatrice.dart';
import 'package:todo/screens/coordinatrice/clientManagement.dart';
import 'package:todo/screens/pages/historique.dart';
import 'package:todo/screens/pages/main_home.dart';
import 'package:todo/screens/pages/notification.dart';
import 'package:todo/screens/pages/profile.dart';

class HomeCordinatrice extends StatefulWidget {
  final String token;
  final String email;
  const HomeCordinatrice({super.key, required this.token, required this.email});

  @override
  State<HomeCordinatrice> createState() => _HomeCordinatriceScreenState();
}

class _HomeCordinatriceScreenState extends State<HomeCordinatrice> {
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
        title: const Text('Home Coordinatrice',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            title: const Text('Phone Tickets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FieldTicket()),
              );
            },
          ),
          ListTile(
              title: const Text('Field Tickets'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FieldTicket()),
                );
              }),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          )
        ],
      )),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PTicketScreen(
                          token: widget.token,
                          //email: email,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 118, 118),
                  minimumSize: Size(140, 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Phone Tickets',
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
                          FieldTicketScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 118, 118),
                  minimumSize: Size(140, 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Fields Tickets',
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
                      builder: (context) => Clientmanagement(
                          token: widget.token, email: widget.email),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 118, 118),
                  minimumSize: Size(140, 120),
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
                          HistoriqueScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 118, 118),
                  minimumSize: Size(140, 120),
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
                      'Historique',
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
                          AlerteCoordinatriceScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 118, 118),
                  minimumSize: Size(140, 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Warnings',
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
                        builder: (context) => ProfileScreen(
                          token: widget.token,
                          email: widget.email,
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 118, 118),
                  minimumSize: Size(140, 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.white, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Profile',
                      style: TextStyle(color: Colors.white), // text color
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
