// lib/main.dart
import 'package:flutter/material.dart';
import 'menu.dart'; // Импортируем файл menu.dart
import 'profile.dart'; // Импортируем файл profile.dart
// import 'auth.dart'; // Импортируем файл авторизации
import 'buy.dart'; // Импортируем файл buy.dart
import 'services/api_service.dart'; // Импортируем файл api_service.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService(); // Создаем экземпляр ApiService
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сытый Лось',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AuthPage(apiService: apiService), // Передаем ApiService в AuthPage
      home: MenuPage(apiService: apiService),
      routes: {
        '/profile': (context) => ProfilePage(apiService: apiService), // Передаем ApiService в ProfilePage
        '/api/menu': (context) => MenuPage(apiService: apiService), // Передаем ApiService в MenuPage
        '/buy': (context) => BuyPage(apiService: apiService), // Передаем ApiService в BuyPage
      },
    );
  }
}