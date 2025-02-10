import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/user.dart'; // Импортируем модель User

class ApiService {
  final String _baseUrl = "http://127.0.0.1:8000/";

  // Метод для выполнения GET-запроса
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Ошибка загрузки данных: ${response.statusCode}');
    }
  }

  // Метод для выполнения POST-запроса
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Ошибка отправки данных: ${response.statusCode}');
    }
  }

  // Метод для регистрации пользователя
  Future<void> register(User user) async {
    try {
      await post('api/register/', user.toJson());
    } catch (error) {
      throw Exception('Ошибка регистрации: $error');
    }
  }

  // Метод для входа пользователя
  Future<User> login(String phone, String password) async {
    try {
      final response = await post('api/login/', {
        'phone': phone, 
        'password': password, 
      });


      return User.fromJson(response);
    } catch (error) {
      throw Exception('Ошибка входа: $error');
    }
  }
}
