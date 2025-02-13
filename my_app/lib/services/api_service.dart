import 'dart:convert';
import 'package:http/http.dart' as http;

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

// Меню

Future<List<dynamic>> getMenu() async {
    final url = Uri.parse('$_baseUrl/api/menu/'); // Используем _baseUrl
    print('Request URL: $url'); // Логируем URL для отладки

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Декодируем ответ с использованием UTF-8
      final responseBody = utf8.decode(response.bodyBytes);
      return jsonDecode(responseBody);
    } else {
      throw Exception('Не удалось загрузить меню. Статус код: ${response.statusCode}');
    }
  }
}

