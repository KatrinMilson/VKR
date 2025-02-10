import 'package:flutter/material.dart';
import 'auth.dart'; // Импортируем AuthPage
import 'menu.dart'; // Импортируем MenuPage
import 'services/api_service.dart'; // Импортируем ApiService
import 'user.dart'; // Импортируем модель User

class ProfilePage extends StatefulWidget {
  final ApiService apiService; // Принимаем ApiService через конструктор

  ProfilePage({required this.apiService}); // Конструктор

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _profileData = {};
  User? _user; // Данные пользователя, переданные из AuthPage

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Загрузка профиля
  Future<void> _loadProfile() async {
    try {
      final data = await widget.apiService.get('profile/');
      setState(() {
        _profileData = data;
      });
    } catch (e) {
      print('Ошибка загрузки профиля: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Получаем данные пользователя, переданные из AuthPage
    final user = ModalRoute.of(context)!.settings.arguments as User?;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Профиль'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Профиль'),
              Tab(text: 'Меню'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Вкладка "Профиль"
            _user != null
                ? Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Имя: ${_user!.name}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Телефон: ${_user!.phone}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                : _profileData.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Имя: ${_profileData['name']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Телефон: ${_profileData['phone']}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
            // Вкладка "Меню"
            MenuPage(apiService: widget.apiService), // Передаем ApiService в MenuPage
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Закомментирован переход на AuthPage с передачей ApiService
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AuthPage(apiService: widget.apiService),
              ),
            );
          },
          child: Icon(Icons.exit_to_app),
          tooltip: 'Выход',
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ),
    );
  }
}