import 'package:amazon_flutter_clone/common/widgets/stars.dart';
import 'package:amazon_flutter_clone/models/product.dart';
import 'package:flutter/material.dart';

class SearchedProducts extends StatelessWidget {
  const SearchedProducts({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Calculate average rating (fixed accumulation + safe null checks)
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
          // Image: fixed but small width so it doesn't dominate space.
          // Use ClipRRect to round corners and BoxFit.cover for consistent crop.
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

          // Use Expanded so the right-side column takes remaining space and won't overflow.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name: allow 2 lines and ellipsis
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Stars widget with some left spacing removed (we're already aligned)
                Stars(rating: averageRating),

                const SizedBox(height: 6),

                // Price
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

                // Extra info
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
