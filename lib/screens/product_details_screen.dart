import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1EA),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.local_grocery_store, size: 80, color: Color(0xFFF28A1D)),
              ),
              const SizedBox(height: 20),
              Text(widget.product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(widget.product.description.isNotEmpty ? widget.product.description : 'Fresh and quality grocery item.'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₱${widget.product.price.toStringAsFixed(0)}/${widget.product.unit}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFF28A1D))),
                  Text('Stock: ${widget.product.stock}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  IconButton(onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1), icon: const Icon(Icons.remove_circle_outline)),
                  Text(quantity.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  IconButton(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final userId = await AuthService.getLoggedInUserId() ?? 0;
                        await DatabaseHelper.instance.addToCart(userId, widget.product.id!, quantity);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart.')),
                        );
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF28A1D)),
                      onPressed: () {},
                      child: const Text('Buy Now', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
