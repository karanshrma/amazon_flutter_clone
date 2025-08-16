import 'package:amazon_flutter_clone/common/widgets/stars.dart';
import 'package:amazon_flutter_clone/models/product.dart';
import 'package:flutter/material.dart';

class SearchedProducts extends StatelessWidget {
  const SearchedProducts({super.key, required this.product});

  final Product product;


  @override
  Widget build(BuildContext context) {
    double averageRating = 0;

    double totalRating = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating = product.rating![i].rating;

    }
    if (totalRating != 0) {
      averageRating = totalRating / product.rating!.length;
    }
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
                    child: Stars(rating: averageRating),
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
