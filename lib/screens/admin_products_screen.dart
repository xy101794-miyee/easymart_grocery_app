import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product_model.dart';
import '../utils/app_theme.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final unitController = TextEditingController();
  final stockController = TextEditingController();
  int selectedCategoryId = 1;
  List<Map<String, dynamic>> categories = [];
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await DatabaseHelper.instance.getCategories();
    final data = await DatabaseHelper.instance.getProducts();
    setState(() {
      categories = cats.map((e) => {'id': e.id, 'name': e.name}).toList();
      products = data;
      if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
    });
  }

  Future<void> _saveProduct() async {
    final product = ProductModel(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      categoryId: selectedCategoryId,
      price: double.tryParse(priceController.text) ?? 0,
      unit: unitController.text.trim().isEmpty ? 'piece' : unitController.text.trim(),
      stock: int.tryParse(stockController.text) ?? 0,
      imagePath: 'assets/images/default_product.png',
      isFeatured: true,
      isAvailable: true,
    );

    await DatabaseHelper.instance.insertProduct(product);
    await _load();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully.')),
    );
  }

  Future<void> _deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage products')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: AppTheme.primaryOrange,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFF7F1EA), child: Icon(Icons.inventory_2_outlined, color: AppTheme.primaryOrange)),
              title: Text(p.name),
              subtitle: Text('${p.stock} ${p.unit} • ₱${p.price.toStringAsFixed(0)}'),
              trailing: IconButton(
                onPressed: () => _deleteProduct(p.id!),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add product'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Product name')),
                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    items: categories
                        .map((e) => DropdownMenuItem<int>(value: e['id'], child: Text(e['name'])))
                        .toList(),
                    onChanged: (value) => selectedCategoryId = value ?? selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  TextField(controller: priceController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Price')),
                  TextField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit')),
                  TextField(controller: stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryOrange),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
