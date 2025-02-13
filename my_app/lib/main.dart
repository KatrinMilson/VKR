import 'package:flutter/material.dart';
import 'services/api_service.dart';
import '/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сытый Лось',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/menu': (context) => MenuPage(apiService: apiService),
      },
      home: MenuPage(apiService: apiService),
    );
  }
}