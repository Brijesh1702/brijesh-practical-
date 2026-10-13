import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pro/main.dart';
import 'package:pro/models/product.dart';
import 'package:pro/providers/product_repository.dart';
import 'package:pro/providers/product_scope.dart';
import 'package:pro/screens/main_screen.dart';

void main() {
  group('Product Model & Repository Unit Tests', () {
    test('Product creation and properties work correctly', () {
      final product = Product(
        id: '100',
        name: 'Test Laptop',
        price: 899.99,
        category: 'Electronics',
        quantity: 5,
        description: 'High performance testing laptop',
      );

      expect(product.id, equals('100'));
      expect(product.name, equals('Test Laptop'));
      expect(product.price, equals(899.99));
      expect(product.category, equals('Electronics'));
      expect(product.quantity, equals(5));
      expect(product.inStock, isTrue);
    });

    test('ProductRepository stores and adds products properly', () {
      final repo = ProductRepository();
      final initialCount = repo.totalProducts;

      final newProduct = Product(
        id: '200',
        name: 'Test Desk',
        price: 150.0,
        category: 'Furniture',
        quantity: 3,
        description: 'Wooden study desk',
      );

      repo.addProduct(newProduct);
      expect(repo.totalProducts, equals(initialCount + 1));
      expect(repo.products.contains(newProduct), isTrue);
    });
  });

  group('Widget & UI Tests', () {
    testWidgets('SplashScreen displays logo and countdown', (WidgetTester tester) async {
      await tester.pumpWidget(const ProductApp());

      // Verify splash screen elements
      expect(find.text('Product Manager Pro'), findsOneWidget);
      expect(find.byIcon(Icons.inventory_2_rounded), findsOneWidget);
      expect(find.text('Skip to App'), findsOneWidget);

      // Fast-forward 10 seconds to test splash screen automatic navigation
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();

      // Should be on Home Screen / MainScreen
      expect(find.text('Product Dashboard'), findsOneWidget);
      expect(find.text('Inventory Overview'), findsOneWidget);
    });

    testWidgets('Bottom Navigation Bar switches tabs correctly', (WidgetTester tester) async {
      final repo = ProductRepository();
      await tester.pumpWidget(
        ProductScope(
          repository: repo,
          child: const MaterialApp(
            home: MainScreen(),
          ),
        ),
      );

      // Verify initial tab is Home
      expect(find.text('Product Dashboard'), findsOneWidget);

      // Tap Product Form tab
      await tester.tap(find.text('Product Form'));
      await tester.pumpAndSettle();
      expect(find.text('Add New Product'), findsOneWidget);

      // Tap Product Grid tab
      await tester.tap(find.text('Product Grid'));
      await tester.pumpAndSettle();
      expect(find.text('Product Catalog Grid'), findsOneWidget);
    });

    testWidgets('Product Form validates required fields', (WidgetTester tester) async {
      await tester.pumpWidget(const ProductApp());

      // Skip splash
      await tester.tap(find.text('Skip to App'));
      await tester.pumpAndSettle();

      // Go to Product Form
      await tester.tap(find.text('Product Form'));
      await tester.pumpAndSettle();

      // Scroll to Save Product button and tap
      final saveButtonFinder = find.text('Save Product');
      await tester.ensureVisible(saveButtonFinder);
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // Verify validation error messages
      expect(find.text('Please enter a product name'), findsOneWidget);
      expect(find.text('Please select a product category'), findsOneWidget);
      expect(find.text('Enter price'), findsOneWidget);
      expect(find.text('Enter quantity'), findsOneWidget);
      expect(find.text('Please enter a product description'), findsOneWidget);
    });

    testWidgets('GridView displays products and onTap opens Card View details', (WidgetTester tester) async {
      await tester.pumpWidget(const ProductApp());

      // Skip splash
      await tester.tap(find.text('Skip to App'));
      await tester.pumpAndSettle();

      // Navigate to Product Grid
      await tester.tap(find.text('Product Grid'));
      await tester.pumpAndSettle();

      // Verify GridView items exist
      expect(find.text('Wireless Headphones'), findsOneWidget);

      // Tap on a product card
      await tester.tap(find.text('Wireless Headphones'));
      await tester.pumpAndSettle();

      // Verify Card detail dialog opens with complete details
      expect(find.text('Product Description'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      // Tap Close button
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Product Description'), findsNothing);
    });
  });
}
