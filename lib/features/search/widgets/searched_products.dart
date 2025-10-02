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
    final ratings = product.rating ?? [];
    for (var r in ratings) {
      totalRating += r.rating;
    }

    if (ratings.isNotEmpty) {
      averageRating = totalRating / ratings.length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.images.isNotEmpty ? product.images[0] : '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  product.name,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),


                Stars(rating: averageRating),

                const SizedBox(height: 6),


                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),


                const Text(
                  'Eligible for free delivery',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'In stock',
                  style: TextStyle(color: Colors.teal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
