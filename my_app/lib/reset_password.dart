import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Импортируем ApiService

class ResetPasswordPage extends StatefulWidget {
  final ApiService apiService; // Принимаем ApiService через конструктор

  ResetPasswordPage({required this.apiService}); // Конструктор

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _resetPassword() async {
    String phone = _phoneController.text;
    String newPassword = _newPasswordController.text;

    // Проверка на пустое поле нового пароля
    if (newPassword.isNotEmpty) {
      // Логика для сброса пароля
      final resetData = {
        'phone': phone,
        'newPassword': newPassword,
      };

      try {
        await widget.apiService.post('reset_password/', resetData); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пароль успешно обновлен для $phone')),
        );
        // После успешного обновления можно вернуться на экран авторизации
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при сбросе пароля: $error')),
        );
      }
    } else {
      // Обработка случая, когда новый пароль не введен
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, введите новый пароль')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Восстановление пароля'),
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
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Новый пароль'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Сбросить пароль'),
            ),
          ],
        ),
      ),
    );
  }
}