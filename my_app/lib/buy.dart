// lib/buy.dart
import 'package:flutter/material.dart';
import 'cart.dart'; // Импортируем файл cart.dart
import 'services/api_service.dart'; // Импортируем ApiService

class BuyPage extends StatelessWidget {
  final ApiService apiService; // Принимаем ApiService через конструктор

  BuyPage({required this.apiService}); // Конструктор

  // Метод для оформления заказа
  void _placeOrder(BuildContext context) async {
    if (Cart.items.isEmpty) {
      // Если корзина пуста, показываем сообщение
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Корзина пуста')),
      );
      return;
    }

    // Подготавливаем данные для отправки
    final orderData = {
      'items': Cart.items.map((item) => {
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
      }).toList(),
      'total_price': Cart.totalPrice,
    };

    try {
      // Отправляем данные на сервер
      final response = await apiService.post('orders/', orderData);

      // Если заказ успешно оформлен
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Заказ успешно оформлен!')),
        );
        Cart.clear(); // Очищаем корзину после успешного заказа
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${response['message']}')),
        );
      }
    } catch (e) {
      // Обработка ошибок
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Cart.items.length,
              itemBuilder: (context, index) {
                final item = Cart.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Количество: ${item.quantity}'),
                  trailing: Text('${item.price * item.quantity}₽'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Общая цена: ${Cart.totalPrice}₽',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _placeOrder(context), // Оформление заказа
              child: Text('Оформить заказ'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Ширина кнопки на весь экран
              ),
            ),
          ),
        ],
      ),
    );
  }
}