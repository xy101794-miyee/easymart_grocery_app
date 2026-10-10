import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/order_model.dart';
import '../utils/app_theme.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<OrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await DatabaseHelper.instance.getAllOrders();
    setState(() => orders = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: ListTile(
              title: Text(order.orderNumber),
              subtitle: Text('${order.status} • ₱${order.total.toStringAsFixed(0)}'),
              trailing: PopupMenuButton<String>(
                onSelected: (val) async {
                  await DatabaseHelper.instance.updateOrderStatus(order.id!, val);
                  await _load();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'Order Placed', child: Text('Order Placed')),
                  PopupMenuItem(value: 'Order Confirmed', child: Text('Order Confirmed')),
                  PopupMenuItem(value: 'Preparing Your Groceries', child: Text('Preparing Your Groceries')),
                  PopupMenuItem(value: 'Ready for Delivery', child: Text('Ready for Delivery')),
                  PopupMenuItem(value: 'Out for Delivery', child: Text('Out for Delivery')),
                  PopupMenuItem(value: 'Delivered', child: Text('Delivered')),
                  PopupMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
