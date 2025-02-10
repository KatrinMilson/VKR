// lib/cart.dart
import 'package:collection/collection.dart'; 
import 'services/api_service.dart'; // Импортируем ApiService

class CartItem {
  final String name;
  int quantity; 
  final double price;

  CartItem(this.name, this.quantity, this.price);
}

class Cart {
  static final List<CartItem> _items = [];

  static void addItem(CartItem item) {

    final existingItem = _items.firstWhereOrNull(
      (cartItem) => cartItem.name == item.name,
    );

    if (existingItem != null) {

      existingItem.quantity += item.quantity;
    } else {

      _items.add(item);
    }
  }

  static void removeItem(String name) {
    _items.removeWhere((item) => item.name == name);
  }

  // Метод для очистки корзины
  static void clear() {
    _items.clear();
  }

  static List<CartItem> get items => _items;

  static double get totalPrice => _items.fold(0, (total, item) => total + (item.price * item.quantity));

  // Метод для отправки данных о корзине на сервер
  static Future<void> sendCart(ApiService apiService) async {
    final cartData = {
      'items': _items.map((item) => {
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
      }).toList(),
      'totalPrice': totalPrice,
    };

    try {
      final response = await apiService.post('cart/', cartData);
      print('Данные корзины успешно отправлены: $response');
    } catch (error) {
      print('Ошибка при отправке данных корзины: $error');
    }
  }
}