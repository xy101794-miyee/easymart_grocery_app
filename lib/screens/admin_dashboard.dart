import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../utils/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic> summary = {};

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final data = await DatabaseHelper.instance.getDashboardSummary();
    setState(() => summary = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _statCard('Products', '${summary['products'] ?? 0}'),
                  _statCard('Categories', '${summary['categories'] ?? 0}'),
                  _statCard('Customers', '${summary['customers'] ?? 0}'),
                  _statCard('Orders', '${summary['orders'] ?? 0}'),
                  _statCard('Pending', '${summary['pending'] ?? 0}'),
                  _statCard('Delivered', '${summary['delivered'] ?? 0}'),
                  _statCard('Low Stock', '${summary['lowStock'] ?? 0}'),
                  _statCard('Sales', '₱0'),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined, color: AppTheme.primaryOrange),
                title: const Text('Manage products'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/admin-products'),
              ),
              ListTile(
                leading: const Icon(Icons.category_outlined, color: AppTheme.primaryOrange),
                title: const Text('Manage categories'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/admin-categories'),
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long, color: AppTheme.primaryOrange),
                title: const Text('View orders'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/admin-orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.primaryOrange)),
        ],
      ),
    );
  }
}
