class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final int quantity;
  final String description;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get inStock => quantity > 0;

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    int? quantity,
    String? description,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
