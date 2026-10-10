class ProductModel {
  final int? id;
  final String name;
  final String description;
  final int categoryId;
  final double price;
  final String unit;
  final int stock;
  final String imagePath;
  final bool isFeatured;
  final bool isAvailable;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.unit,
    required this.stock,
    required this.imagePath,
    this.isFeatured = false,
    this.isAvailable = true,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      categoryId: map['category_id'] as int? ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] as String? ?? 'piece',
      stock: map['stock'] as int? ?? 0,
      imagePath: map['image_path'] as String? ?? '',
      isFeatured: (map['is_featured'] as int?) == 1,
      isAvailable: (map['is_available'] as int?) != 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category_id': categoryId,
      'price': price,
      'unit': unit,
      'stock': stock,
      'image_path': imagePath,
      'is_featured': isFeatured ? 1 : 0,
      'is_available': isAvailable ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}
