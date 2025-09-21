import 'package:amazon_flutter_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_flutter_clone/home/services/home_service.dart';
import 'package:amazon_flutter_clone/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/utils.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  final HomeService homeService = HomeService();
  Product? product;

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product = await homeService.fetchDealOfDay(context: context);
    setState(() {});
  }

  void navigateToDetails() {
    Navigator.pushNamed(
      context,
      ProductDetailsScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? Center(
            child: const Text(
              'Deals Coming Soon... Stay Tuned!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : product!.name.isEmpty
        ? const SizedBox()
        : GestureDetector(
            onTap: navigateToDetails,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 10, top: 8),
                  child: Text(
                    'Deal of the day',
                    style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: product!.images[0],
                      height: 235,
                      fit: BoxFit.fitHeight,
                      errorWidget: (context, error, stackTrace) {
                        return CachedNetworkImage(
                          imageUrl: defaultImageUrl, // your fallback image
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product!.name,
                        style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('\$${100}', style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ).copyWith(left: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'See all deals!',
                    style: TextStyle(color: Colors.cyan[800] , fontSize: 16),
                  ),
                ),
              ],
            ),
          );
  }
}
