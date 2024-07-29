import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/text_field.dart';
import 'package:todo/screens/Manager/homeManager.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/config/config.dart';
import 'package:todo/screens/coordinatrice/homeCordinatrice.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/utils/toast.dart';
import 'package:todo/screens/config/config_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> login() async {
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        var loginBody = {
          "email": emailController.text,
          "password": passwordController.text,
        };

        print("Attempting to log in with body: $loginBody");
        Utils.showToast("Logging in...");
        //     var address = ConfigService().adresse;
        //    var port = ConfigService().port;
        var url = "http://192.168.93.54:4000/api/user/login";

        var response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(loginBody),
        );

        // Logging the response status code
        print("Received response with status code: ${response.statusCode}");

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);

          // Logging the response data
          print("Login successful, response data: $responseData");

          var myToken = responseData["token"];
          var email = responseData["email"];
          var role = responseData["role"];

          Utils.showToast("Logged in successfully");
          Utils.showToast(email);
          Utils.showToast(role);

          // Logging the token, email, and role
          print("Token: $myToken, Email: $email, Role: $role");

          prefs.setString("token", myToken);
          prefs.setString("email", email);
          prefs.setString("role", role);

          // Redirect based on role
          if (role == "COORDINATRICE") {
            print("Redirecting to HomeCordinatrice");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeCordinatrice(token: myToken, email: email),
              ),
            );
          } else if (role == "MANAGER") {
            print("Redirecting to HomeManager");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeManager(token: myToken, email: email),
              ),
            );
          } else {
            print("Redirecting to HomeScreen");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(token: myToken, email: email),
              ),
            );
          }
        } else {
          var errorResponse = jsonDecode(response.body);

          // Logging the error response
          print("Login failed, error response: $errorResponse");

          Utils.showToast("Login failed: ${errorResponse['error']}");
          setState(() {
            errorMessage = errorResponse['error'];
          });
        }
      } else {
        Utils.showToast("Please fill all the fields");
      }
    } catch (e) {
      // Logging the exception
      print("Error occurred during login: $e");
      Utils.showToast("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 100.0),
              child: Image.asset(
                'assets/tu.png',
                width: 220,
                height: 150,
              ),
            ),
            const SizedBox(height: 100),
            TextInput(
              controller: emailController,
              label: "Email",
            ),
            TextInput(
              controller: passwordController,
              label: "Password",
              isPass: true,
            ),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Server configuration : "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfigScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Configuration',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
