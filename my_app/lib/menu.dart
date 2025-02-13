import 'package:flutter/material.dart';
import 'services/api_service.dart';

class MenuPage extends StatelessWidget {
  final ApiService apiService;

  MenuPage({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getMenu(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки меню: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Меню пусто'));
          } else {
            var menuItems = snapshot.data!;
            return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                var item = menuItems[index];
                return ListTile(
                  title: Text(item['title'] ?? 'Нет названия'),
                  subtitle: Text(item['description'] ?? 'Нет описания'),
                  trailing: Text('\$${item['price'] ?? '0.00'}'),
                  onTap: () {
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}