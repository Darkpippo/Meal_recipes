import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meal_recipes/screens/categories_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC4Ak2VXHpi75HXPBk1T-73uisjDev61CI",
          authDomain: "meal-recipes-6eee0.firebaseapp.com",
          projectId: "meal-recipes-6eee0",
          storageBucket: "meal-recipes-6eee0.firebasestorage.app",
          messagingSenderId: "236918273080",
          appId: "1:236918273080:web:5cfdb860b3595917aca2cd",
          measurementId: "G-51N6T4KZCC"),
    );
  } else {
    await Firebase.initializeApp();
  }

  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Recipes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CategoriesScreen(),
    );
  }
}
