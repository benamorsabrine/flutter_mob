import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/config/config_service.dart';

class ProfileScreen extends StatefulWidget {
  final String token;
  final String email;

  const ProfileScreen({Key? key, required this.token, required this.email})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? firstname;
  String? lastname;
  String? email;
  String? role;
  String? password;
  bool isLoading = true;
  bool isError = false;
  String errorMessage = '';
  bool isPasswordVisible = false;
    var address = ConfigService().adresse;
    var port = ConfigService().port;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('$address:$port/api/user/email/${widget.email}'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          firstname = responseData['firstname'] as String? ??
              '';
          lastname = responseData['lastname'] as String? ?? '';
          email = responseData['email'] as String? ?? '';
          role = responseData['role'] as String? ?? '';
          password = responseData['password'] as String? ?? '';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to retrieve user profile data');
      }
    } catch (error) {
      setState(() {
        isError = true;
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            _buildTextField('Prénom', firstname),
            _buildTextField('Nom', lastname),
            _buildTextField('Adresse Email', email),
            _buildTextField('Role', role),
            _buildTextField(
              'Mot de passe',
              password,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              obscureText: !isPasswordVisible,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String? value,
      {Widget? suffixIcon, bool obscureText = false}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
      ),
      readOnly: true,
      controller: TextEditingController(text: value ?? ''),
      obscureText: obscureText,
    );
  }
}