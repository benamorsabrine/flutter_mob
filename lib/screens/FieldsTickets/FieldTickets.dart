import 'package:flutter/material.dart';
import 'package:todo/screens/FieldsTickets/AcceptedFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/ArrivedFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/AssignedFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/EnRouteFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/LoadingFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/ReportedFieldTicket.dart';
import 'package:todo/screens/FieldsTickets/SolvedFieldTicket.dart';

class FieldTicketScreen extends StatefulWidget {
  final String token;

  const FieldTicketScreen({Key? key, required this.token});

  @override
  State<FieldTicketScreen> createState() => _FieldTicketScreenState();
}

class _FieldTicketScreenState extends State<FieldTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Process Tickets',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      body: Column(children: [
        const SizedBox(height: 70), // space between AppBar and first row
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
                      builder: (context) => FieldAssignedScreen(
                        token: widget.token,
                      ),
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
                    Icon(Icons.assignment,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Assigned Tickets',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20), // space between buttons
            SizedBox(
              width: 170,
              height: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FieldAcceptedScreen(
                        token: widget.token,
                      ),
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
                    Icon(Icons.check_circle,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
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
                          FieldEnRouteScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 238, 0), // background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'EnRoute Tickets',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20), // space between buttons
            SizedBox(
              width: 170,
              height: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FieldArrivedScreen(
                        token: widget.token,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 128, 0, 255), // background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Arrived Tickets',
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
                          FieldLoadingScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 157, 0), // background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timelapse,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Loading Tickets',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20), // space between buttons
            SizedBox(
              width: 170,
              height: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FieldSolvedScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 37, 146, 255), // background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Solved Tickets',
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
                          FieldReportedScreen(token: widget.token),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 92, 92, 92), // background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // border radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month,
                        color: Colors.white, size: 40), // Icon added here
                    SizedBox(
                        height:
                            15), // Adjust the spacing between the icon and the label
                    Text(
                      'Reported Tickets',
                      style: TextStyle(color: Colors.white), // text color
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
