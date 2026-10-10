class CategoryModel {
  final int? id;
  final String name;
  final String? createdAt;

  CategoryModel({this.id, required this.name, this.createdAt});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }
}
