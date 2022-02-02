import 'package:flutter/material.dart';

// Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import '../services/navigation_service.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/database_service.dart';



class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({required Key key, required this.onInitializationComplete})
      : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initStated
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((_) {
      _setup().then(
        (_) => widget.onInitializationComplete(),
      );
    });
  }

  // Initialize the FireBase
  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  // Register the Services
  //Get it used for singleton object
  void _registerServices() {
    final getIt = GetIt.instance;
    getIt.registerSingleton<NavigationService>(NavigationService());
    getIt.registerSingleton<MediaService>(MediaService());
    getIt.registerSingleton<CloudStorageService>(CloudStorageService());
    getIt.registerSingleton<DatabaseService>(DatabaseService());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashify',
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        scaffoldBackgroundColor: Colors.lightBlueAccent,
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('images/FlashifyLogo.png'),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
