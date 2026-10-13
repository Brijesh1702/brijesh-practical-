import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductRepository extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  int get totalProducts => _products.length;

  int get totalStock => _products.fold(0, (sum, p) => sum + p.quantity);

  double get totalValue =>
      _products.fold(0.0, (sum, p) => sum + (p.price * p.quantity));

  ProductRepository() {
    // Initialize with initial product data
    _products.addAll([
      Product(
        id: '1',
        name: 'Wireless Headphones',
        price: 99.99,
        category: 'Electronics',
        quantity: 15,
        description:
            'High-quality noise-canceling wireless bluetooth headphones with long battery life and comfortable ear cups.',
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        price: 199.50,
        category: 'Electronics',
        quantity: 8,
        description:
            'Fitness tracker smart watch with heart rate monitor, GPS tracking, and 50m water resistance.',
      ),
      Product(
        id: '3',
        name: 'Cotton T-Shirt',
        price: 24.99,
        category: 'Clothing',
        quantity: 50,
        description:
            '100% organic soft breathable cotton t-shirt available in multiple sizes and modern colors.',
      ),
      Product(
        id: '4',
        name: 'Dart & Flutter Guide',
        price: 39.90,
        category: 'Books',
        quantity: 20,
        description:
            'Comprehensive step-by-step guide to building cross-platform mobile apps using Flutter and Dart.',
      ),
      Product(
        id: '5',
        name: 'Organic Coffee Beans',
        price: 18.75,
        category: 'Food & Groceries',
        quantity: 35,
        description:
            'Premium medium roast dark organic whole coffee beans sourced from high-altitude fair-trade farms.',
      ),
      Product(
        id: '6',
        name: 'Ergonomic Desk Chair',
        price: 249.00,
        category: 'Furniture',
        quantity: 5,
        description:
            'Breathable mesh back ergonomic office desk chair with adjustable lumbar support and 3D armrests.',
      ),
    ]);
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  bool removeProduct(String id) {
    final initialLength = _products.length;
    _products.removeWhere((p) => p.id == id);
    if (_products.length != initialLength) {
      notifyListeners();
      return true;
    }
    return false;
  }
}
