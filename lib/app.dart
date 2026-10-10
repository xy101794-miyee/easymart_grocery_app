import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'screens/admin_categories_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/admin_orders_screen.dart';
import 'screens/admin_products_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';

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
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/admin': (_) => const AdminDashboardScreen(),
        '/admin-products': (_) => const AdminProductsScreen(),
        '/admin-categories': (_) => const AdminCategoriesScreen(),
        '/admin-orders': (_) => const AdminOrdersScreen(),
      },
    );
  }
}
