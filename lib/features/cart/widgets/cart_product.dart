import 'package:amazon_flutter_clone/features/cart/services/cart_service.dart';
import 'package:amazon_flutter_clone/features/product_details/services/product_details_service.dart';
import 'package:amazon_flutter_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/stars.dart';
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

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.contain,
                width: 135,
                height: 135,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 235,
                    child: Text(
                      product.name,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    width: 235,
                    child: Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 235,
                    child: const Text(
                      'Eligible for free delivery',
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 235,
                    child: const Text(
                      'In stock',
                      style: TextStyle(color: Colors.teal),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black12,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => decreaseQuantity(product),

                                child: Container(
                                  width: 35,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.remove, size: 18),
                                ),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  width: 35,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: Text(quantity.toString()),
                                ),
                              ),
                              InkWell(
                                onTap: () => increaseQuantity(product),
                                child: Container(
                                  width: 35,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.add, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(),
      ],
    );
  }
}
