import 'package:flutter/material.dart';
import 'providers/product_repository.dart';
import 'providers/product_scope.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ProductApp());
}

class ProductApp extends StatefulWidget {
  const ProductApp({super.key});

  @override
  State<ProductApp> createState() => _ProductAppState();
}

class _ProductAppState extends State<ProductApp> {
  late final ProductRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = ProductRepository();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductScope(
      repository: _repository,
      child: MaterialApp(
        title: 'Product Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
