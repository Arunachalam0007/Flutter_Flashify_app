// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pages
import '../pages/login_page.dart';
import '../pages/splash_page.dart';
import '../pages/home_page.dart';
import '../pages/register_page.dart';

// Services
import '../services/navigation_service.dart';


// Providers
import '../providers/authentication_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(create: (context) => AuthenticationProvider()),
      ],
      child: MaterialApp(
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
          '/register': (context) => RegisterPage(),
          '/home' : (context) => HomePage(),
        },
        initialRoute: '/login',
        navigatorKey: NavigationService.navigatorKey,
      ),
    );
  }
}

