import 'package:flutter/material.dart';
import 'product_repository.dart';

class ProductScope extends InheritedNotifier<ProductRepository> {
  const ProductScope({
    super.key,
    required ProductRepository repository,
    required super.child,
  }) : super(notifier: repository);

  static ProductRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProductScope>();
    assert(scope != null, 'No ProductScope found in context');
    return scope!.notifier!;
  }
}
