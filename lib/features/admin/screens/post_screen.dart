import 'package:amazon_flutter_clone/features/admin/screens/add_products.dart';
import 'package:amazon_flutter_clone/features/admin/services/admin_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products;
  final AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminService.fetchAllProducts(context);
    setState(() {});
  }

  Future<void> deleteProduct(Product product, int index) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Remove this item from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (shouldRemove == true) {
      adminService.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          products!.removeAt(index);
          setState(() {});
        },
      );
    }
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProducts.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? Loader()
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: GridView.builder(
                  itemCount: products!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio:
                        0.75, // Adjust this ratio to fit content properly
                  ),
                  itemBuilder: (context, index) {
                    final productData = products![index];
                    return Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image container with fixed height
                            Expanded(
                              flex: 3, // Takes 3/5 of the available space
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: productData.images[0],
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) {
                                      return CachedNetworkImage(
                                        imageUrl: defaultImageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Product details section
                            Expanded(
                              flex: 2, // Takes 2/5 of the available space
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product name
                                  Flexible(
                                    child: Text(
                                      productData.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Price and delete button row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${productData.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            deleteProduct(productData, index),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              onPressed: navigateToAddProduct,
              backgroundColor:  Color.fromARGB(255, 29, 201, 192),
              child: Icon(Icons.add, color: Colors.black),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
  }
}
