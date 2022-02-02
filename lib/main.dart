
import 'package:flutter/material.dart';

// Packages
import '../pages/login_page.dart';
import '../pages/splash_page.dart';
import '../services/navigation_service.dart';


void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(MainApp());
      },
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Page',
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30,29,37,1.0),
        ),
      ),
      routes: {
        '/login': (context) => LoginPage(),
      },
      initialRoute: '/login',
      navigatorKey: NavigationService.navigatorKey,
    );
  }
}

