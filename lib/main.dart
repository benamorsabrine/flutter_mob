import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/Manager/alerteManager.dart';
import 'package:todo/screens/Manager/historiqueManager.dart';
import 'package:todo/screens/Manager/homeManager.dart';
import 'package:todo/screens/auth/login_screen.dart';
import 'package:todo/screens/coordinatrice/homeCordinatrice.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/pages/historique.dart';
import 'package:todo/screens/tickets/phoneAssigned.dart';
import 'package:todo/screens/tickets/phoneaccepted.dart';
import 'package:todo/screens/tickets/phonearrived.dart';
import 'package:todo/screens/tickets/phonedeparture.dart';
import 'package:todo/screens/tickets/phoneloading.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();  String? token = prefs.getString('token');
  String? email = prefs.getString('email');
  String? userRole = prefs.getString('role');
  runApp(MyApp(token: token, email: email, userRole: userRole));
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? email;
  final String? userRole;

  const MyApp(
      {Key? key,
      required this.token,
      required this.email,
      required this.userRole})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTokenExpired = token == null || JwtDecoder.isExpired(token!);
    bool isCoordinatrice = userRole == "COORDINATRICE";
    bool isManager =userRole == "MANAGER";
    final Map<String, WidgetBuilder> coordinatorRoutes = {
      '/assignedphone': (context) => PhoneAssignedScreen(token: token!),
      '/acceptedphone': (context) => PhoneAcceptedScreen(token: token!),
      '/departurephone': (context) => PhoneDepartureScreen(token: token!),
      '/arrivedphone': (context) => PhoneArrivedScreen(token: token!),
      '/loadingphone': (context) => PhoneLoadingScreen(token: token!),
    };

    final Map<String, WidgetBuilder> managerRoutes = {
      '/alertemanager': (context) => AlerteManagerScreen(token: token!),
      '/historique': (context) => HistoriqueManagerScreen(token: token!),
    };

    final Map<String, WidgetBuilder> appRoutes = {};
    if (isCoordinatrice) {
      appRoutes.addAll(coordinatorRoutes);
    } else if (isManager) {
      appRoutes.addAll(managerRoutes);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tunisys',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 185, 6, 6)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routes: appRoutes,
      home: isTokenExpired
          ? const LoginScreen()
          : isCoordinatrice
              ? HomeCordinatrice(
                  token: token!,
                  email: email!,
                )
              : isManager
                  ? HomeManager(
                      token: token!,
                      email: email!,
                    )
                  : HomeScreen(
                      token: token!,
                      email: email!,
                    ),
    );
  }
}
