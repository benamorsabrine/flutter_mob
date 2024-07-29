import 'package:flutter/material.dart';
import 'package:todo/screens/coordinatrice/phoneTicketsCoordinatrice/phoneAssigned.dart';
import 'package:todo/screens/coordinatrice/phoneTicketsCoordinatrice/phoneaccepted.dart';
import 'package:todo/screens/coordinatrice/phoneTicketsCoordinatrice/phoneloading.dart';
import 'package:todo/screens/coordinatrice/phoneTicketsCoordinatrice/phonesolved.dart';

class PTicketScreen extends StatefulWidget {
  final String token;
  final String? email;

  const PTicketScreen({Key? key, required this.token, this.email})
      : super(key: key);

  @override
  _PTicketScreenScreenState createState() => _PTicketScreenScreenState();
}

class _PTicketScreenScreenState extends State<PTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Phone Tickets',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 150),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhoneAssignedScreen(token: widget.token),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 108, 182, 211), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // border radius
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment, color: Colors.white, size: 40),
                      SizedBox(height: 15),
                      Text(
                        'Assigned Tickets',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                height: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhoneAcceptedScreen(token: widget.token),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 255, 1, 115), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // border radius
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 40),
                      SizedBox(height: 15),
                      Text(
                        'Accepted Tickets',
                        style: TextStyle(color: Colors.white), // text color
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhoneLoadingScreen(token: widget.token),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 255, 82, 20), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // border radius
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_locked_sharp, color: Colors.white, size: 40),
                      SizedBox(height: 15),
                      Text(
                        'Loading Tickets',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                height: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhoneSolvedScreen(token: widget.token),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 38, 154, 227), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // border radius
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 40),
                      SizedBox(height: 15),
                      Text(
                        'Solved Tickets',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
