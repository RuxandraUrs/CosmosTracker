import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:hive_flutter/hive_flutter.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'core/service_locator.dart' as di; 
import 'core/constants.dart';
import 'data/models/iss_position_model.dart'; 

import 'core/notification_service.dart';

// --- IMPORT PAGINI ---
import 'presentation/pages/welcome_page.dart';     
import 'presentation/pages/iss_tracker_page.dart'; 
import 'presentation/pages/favorites_page.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await di.init();

  await Hive.initFlutter();

  Hive.registerAdapter(IssPositionModelAdapter());

  await Hive.openBox(AppConstants.favoritesBox);

  await NotificationService().init();

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
    ),
    
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const IssTrackerPage(),
    ),
    
    GoRoute(
      path: '/history',
      builder: (context, state) => const FavoritesPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Cosmos Tracker',
      debugShowCheckedModeBanner: false, 
      
      theme: ThemeData(
        brightness: Brightness.dark, 
        
        scaffoldBackgroundColor: const Color(0xFF0B0D17), 
        
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent, 
          secondary: Colors.blueAccent,     
          surface: Color(0xFF15192B),       
          onSurface: Colors.white,          
        ),
        
        useMaterial3: true,
        fontFamily: 'Roboto', 
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22, 
            fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
    );
  }
}