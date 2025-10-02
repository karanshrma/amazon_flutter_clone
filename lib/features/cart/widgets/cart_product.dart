import 'package:amazon_flutter_clone/features/cart/services/cart_service.dart';
import 'package:amazon_flutter_clone/features/product_details/services/product_details_service.dart';
import 'package:amazon_flutter_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({super.key, required this.index});

  final int index;

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsService productDetailsService = ProductDetailsService();
  final CartService cartService = CartService();

  void increaseQuantity(Product product) {
    productDetailsService.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product) {
    cartService.removeFromCart(context: context, product: product);
  }

  Future<void> _confirmAndRemove(Product product) async {
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
      cartService.removeFromCart(context: context, product: product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.images[0],
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Product Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),

                // Free Delivery Text
                const Text(
                  'Eligible for free delivery',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),

                // Stock Status
                const Text(
                  'In stock',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Quantity Controls
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Decrease Button
                          InkWell(
                            onTap: () {
                              if (quantity > 1) {
                                decreaseQuantity(product);
                              }
                              else {
                                _confirmAndRemove(product);
                              }
                            },
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                            ),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: quantity > 1
                                    ? Colors.grey.shade100
                                    : Colors.grey.shade200,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: quantity > 1
                                    ? Colors.black87
                                    : Colors.grey,
                              ),
                            ),
                          ),

                          // Quantity Display
                          Container(
                            width: 40,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.symmetric(
                                vertical: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          // Increase Button
                          InkWell(
                            onTap: () => increaseQuantity(product),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove Item'),
                            content: const Text('Remove this item from cart?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _confirmAndRemove(product);
                                  Navigator.pop(context);
                                },
                                child: const Text('Remove'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () => _confirmAndRemove(product),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
