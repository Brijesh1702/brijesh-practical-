import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;

  const ProductDetailDialog({
    super.key,
    required this.product,
  });

  static Future<void> show(BuildContext context, Product product) {
    return showDialog(
      context: context,
      builder: (context) => ProductDetailDialog(product: product),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Colors.blue;
      case 'clothing':
        return Colors.purple;
      case 'books':
        return Colors.amber.shade800;
      case 'food & groceries':
      case 'food':
        return Colors.green;
      case 'furniture':
        return Colors.deepOrange;
      default:
        return Colors.teal;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices_rounded;
      case 'clothing':
        return Icons.checkroom_rounded;
      case 'books':
        return Icons.menu_book_rounded;
      case 'food & groceries':
      case 'food':
        return Icons.restaurant_rounded;
      case 'furniture':
        return Icons.chair_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = _getCategoryColor(product.category);
    final formattedDate =
        '${product.createdAt.year}-${product.createdAt.month.toString().padLeft(2, '0')}-${product.createdAt.day.toString().padLeft(2, '0')}';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner Card Top
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor,
                      categoryColor.withAlpha(200),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Icon(
                        _getCategoryIcon(product.category),
                        size: 40,
                        color: categoryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(64),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product Information Card Body
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price & Stock Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          context,
                          title: 'Price',
                          value: '\$${product.price.toStringAsFixed(2)}',
                          icon: Icons.attach_money_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoCard(
                          context,
                          title: 'Quantity',
                          value: '${product.quantity} units',
                          icon: Icons.inventory_rounded,
                          color: product.inStock ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Additional Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          context,
                          title: 'Total Value',
                          value:
                              '\$${(product.price * product.quantity).toStringAsFixed(2)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoCard(
                          context,
                          title: 'Added Date',
                          value: formattedDate,
                          icon: Icons.calendar_today_rounded,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Description Label & Box
                    const Text(
                      'Product Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Close Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        label: const Text('Close'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
