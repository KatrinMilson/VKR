// lib/menu.dart
import 'package:flutter/material.dart';
import 'cart.dart'; // Импортируем файл cart.dart
import 'services/api_service.dart'; // Импортируем ApiService

class MenuPage extends StatefulWidget {
  final ApiService apiService; // Принимаем ApiService через конструктор

  MenuPage({required this.apiService}); // Конструктор

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Category> _categories = []; // Список категорий с блюдами
  bool _isLoading = true; // Индикатор загрузки

  @override
  void initState() {
    super.initState();
    _loadMenu(); // Загружаем меню при инициализации
  }

  // Загрузка меню с API
  Future<void> _loadMenu() async {
    try {
      final data = await widget.apiService.get('/api/menu'); // Эндпоинт для загрузки меню

      // Преобразуем данные из API в список категорий и блюд
      setState(() {
        _categories = (data as List).map((category) {
          return Category(
            category['name'],
            (category['dishes'] as List).map((dish) {
              return Dish(
                dish['name'],
                dish['description'],
                dish['price'].toDouble(),
              );
            }).toList(),
          );
        }).toList();

        _isLoading = false; // Скрываем индикатор загрузки
      });
    } catch (e) {
      print('Ошибка загрузки меню: $e');
      setState(() {
        _isLoading = false; // Скрываем индикатор загрузки даже при ошибке
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/buy'); // Переход на страницу корзины
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Индикатор загрузки
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(_categories[index].name),
                  children: _categories[index].dishes.map((dish) {
                    return ListTile(
                      title: Text(dish.name),
                      subtitle: Text('${dish.description} - ${dish.price}₽'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              Cart.removeItem(dish.name); // Удаление блюда из корзины
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${dish.name} убрано из корзины')),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Cart.addItem(CartItem(dish.name, 1, dish.price)); // Добавление блюда в корзину
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${dish.name} добавлено в корзину')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}

// Модель категории
class Category {
  final String name;
  final List<Dish> dishes;

  Category(this.name, this.dishes);
}

// Модель блюда
class Dish {
  final String name;
  final String description;
  final double price;

  Dish(this.name, this.description, this.price);
}