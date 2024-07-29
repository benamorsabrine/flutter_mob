import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  late Map<String, dynamic> _config;

  factory ConfigService() {
    return _instance;
  }

  ConfigService._internal();

  Future<void> loadConfig() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/config.json');

      if (file.existsSync()) {
        final configString = await file.readAsString();
        _config = json.decode(configString);
      } else {
        final configString = await rootBundle.loadString('assets/config.json');
        _config = json.decode(configString);
      }
    } catch (e) {
      print("Error loading config: $e");
    }
  }

  Future<void> saveConfig() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/config.json');
      await file.writeAsString(json.encode(_config));
    } catch (e) {
      print("Error saving config: $e");
    }
  }

  String get adresse => _config['adresse'];
  set adresse(String value) {
    _config['adresse'] = value;
  }

  String get port => _config['port'];
  set port(String value) {
    _config['port'] = value;
  }
}
