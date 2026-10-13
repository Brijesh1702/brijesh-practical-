import 'package:flutter/material.dart';
import '../providers/product_scope.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_dialog.dart';

class ProductGridScreen extends StatefulWidget {
  final VoidCallback? onAddProductPressed;

  const ProductGridScreen({
    super.key,
    this.onAddProductPressed,
  });

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  String _searchQuery = '';
  String _selectedFilterCategory = 'All';

  final List<String> _filterCategories = [
    'All',
    'Electronics',
    'Clothing',
    'Books',
    'Food & Groceries',
    'Furniture',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repository = ProductScope.of(context);
    final allProducts = repository.products;

    // Filter products based on search and category filter
    final filteredProducts = allProducts.where((product) {
      final matchesQuery = product.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedFilterCategory == 'All' ||
          product.category.toLowerCase() ==
              _selectedFilterCategory.toLowerCase();
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Catalog Grid',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${allProducts.length} Items',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Category Chips Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Field
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products by name or details...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Horizontal Category Filter List
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterCategories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _filterCategories[index];
                      final isSelected = _selectedFilterCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilterCategory = category;
                            });
                          }
                        },
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                        visualDensity: VisualDensity.compact,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // GridView Display Section
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState(context, repository.products.isEmpty)
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine responsive column count
                      int crossAxisCount = 2;
                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 3;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              // Requirement 12 & 13: onTap functionality -> display complete product details in Card View
                              ProductDetailDialog.show(context, product);
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool noProductsAtAll) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              noProductsAtAll
                  ? Icons.inventory_2_outlined
                  : Icons.search_off_rounded,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              noProductsAtAll
                  ? 'No Products in Catalog'
                  : 'No Matching Products Found',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              noProductsAtAll
                  ? 'Get started by adding your first product to the inventory form.'
                  : 'Try adjusting your search keywords or category filters.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            if (noProductsAtAll && widget.onAddProductPressed != null)
              ElevatedButton.icon(
                onPressed: widget.onAddProductPressed,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Product Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
