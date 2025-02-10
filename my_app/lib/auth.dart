import 'package:flutter/material.dart';
import 'reg.dart'; // Импортируем файл регистрации
import 'reset_password.dart'; // Импортируем файл восстановления пароля
import 'services/api_service.dart'; // Импортируем ApiService
import 'user.dart'; // Импортируем модель User

class AuthPage extends StatefulWidget {
  final ApiService apiService; // Принимаем ApiService через конструктор

  AuthPage({required this.apiService}); // Конструктор

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Для отображения индикатора загрузки

  void _login() async {
    String phone = _phoneController.text;
    String password = _passwordController.text;

    // Проверка на пустые поля
    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Показываем индикатор загрузки
    });

    try {
      // Используем метод login из ApiService
      User user = await widget.apiService.login(phone, password);

      // Если авторизация успешна
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вход выполнен успешно!')),
      );

      // Переход на страницу профиля с передачей данных пользователя
      Navigator.pushReplacementNamed(
        context,
        '/profile',
        arguments: user, // Передаем объект User
      );
    } catch (e) {
      // Обработка ошибок
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Скрываем индикатор загрузки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Номер телефона'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Индикатор загрузки
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Войти'),
                  ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Переход на страницу регистрации
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage(apiService: widget.apiService)),
                );
              },
              child: Text('Зарегистрироваться'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Переход на страницу восстановления пароля
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage(apiService: widget.apiService)),
                );
              },
              child: Text('Восстановить пароль'),
            ),
          ],
        ),
      ),
    );
  }
}