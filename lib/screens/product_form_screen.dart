import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/product_scope.dart';

class ProductFormScreen extends StatefulWidget {
  final VoidCallback? onProductSaved;

  const ProductFormScreen({
    super.key,
    this.onProductSaved,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Food & Groceries',
    'Furniture',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text.trim());
      final category = _selectedCategory!;
      final quantity = int.parse(_quantityController.text.trim());
      final description = _descriptionController.text.trim();

      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        price: price,
        category: category,
        quantity: quantity,
        description: description,
      );

      final repo = ProductScope.of(context);
      repo.addProduct(newProduct);

      // Reset form
      _formKey.currentState!.reset();
      _nameController.clear();
      _priceController.clear();
      _quantityController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product "$name" added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'View Grid',
            textColor: Colors.white,
            onPressed: () {
              if (widget.onProductSaved != null) {
                widget.onProductSaved!();
              }
            },
          ),
        ),
      );

      // Trigger callback if provided
      if (widget.onProductSaved != null) {
        widget.onProductSaved!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(100),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(50),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_shopping_cart_rounded,
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Details Form',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Enter product information below to add to inventory.',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Product Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name *',
                  hintText: 'e.g. Wireless Headphones',
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a product name';
                  }
                  if (value.trim().length < 2) {
                    return 'Product name must be at least 2 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Field
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category *',
                  hintText: 'Select category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _categories.map((String cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a product category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price & Quantity Row
              Row(
                children: [
                  // Price
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Price (\$) *',
                        hintText: '0.00',
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter price';
                        }
                        final parsed = double.tryParse(value.trim());
                        if (parsed == null) {
                          return 'Invalid number';
                        }
                        if (parsed <= 0) {
                          return 'Price must be > 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Quantity
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantity *',
                        hintText: '0',
                        prefixIcon: const Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter quantity';
                        }
                        final parsed = int.tryParse(value.trim());
                        if (parsed == null) {
                          return 'Invalid integer';
                        }
                        if (parsed < 0) {
                          return 'Must be >= 0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Product Description *',
                  hintText: 'Provide detailed specifications and features...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.description_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a product description';
                  }
                  if (value.trim().length < 5) {
                    return 'Description must be at least 5 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Submit / Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saveProduct,
                  icon: const Icon(Icons.save_rounded, color: Colors.white),
                  label: const Text(
                    'Save Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
