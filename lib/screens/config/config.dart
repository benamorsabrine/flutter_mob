import 'package:flutter/material.dart';
import 'package:todo/components/text_field.dart';
import 'package:todo/screens/auth/login_screen.dart';
import 'package:todo/utils/toast.dart';
import 'config_service.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);
  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController portController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  final ConfigService configService = ConfigService();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initConfig();
  }

  void _initConfig() async {
    await configService.loadConfig();
    setState(() {
      adresseController.text = configService.adresse;
      portController.text = configService.port;
    });
  }

  Future<void> saveConfig() async {
    if (portController.text.isNotEmpty && adresseController.text.isNotEmpty) {
      configService.adresse = adresseController.text;
      configService.port = portController.text;
      await configService.saveConfig();
      Utils.showToast("Configuration saved successfully");
    } else {
      Utils.showToast("Please fill all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuration',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color.fromRGBO(209, 77, 90, 1),
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text("Adresse de serveur"),
              TextInput(
                controller: adresseController,
                label: "Adresse de serveur",
              ),
              Text("Port de serveur"),
              TextInput(
                controller: portController,
                label: "Port de serveur",
              ),
              ElevatedButton(
                onPressed: saveConfig,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Configure'),
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
