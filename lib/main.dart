import 'dart:io';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initPrefs();
  await DatabaseHelper.instance.seedDemoData();

  runApp(const EasymartApp());
}

class EasymartApp extends StatelessWidget {
  const EasymartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easymart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin-products': (context) => const AdminProductsScreen(),
        '/admin-categories': (context) => const AdminCategoriesScreen(),
        '/admin-orders': (context) => const AdminOrdersScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
