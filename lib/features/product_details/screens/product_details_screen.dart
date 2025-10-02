import 'package:amazon_flutter_clone/common/widgets/custom_elevatedbutton.dart';

import 'package:amazon_flutter_clone/features/address/screens/address_screen.dart';
import 'package:amazon_flutter_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_flutter_clone/features/product_details/services/product_details_service.dart';
import 'package:amazon_flutter_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/stars.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../search/screens/search_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  static const String routeName = '/products-details-screen';

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsService productDetailsService = ProductDetailsService();

  double averageRating = 0;
  double myrating = 0;

  @override
  void initState() {
    super.initState();

    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating = widget.product.rating![i].rating;
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myrating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      averageRating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearch(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    productDetailsService.addToCart(context: context, product: widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item has been added to cart'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int totalQuantity = user.cart.fold(
      0,
      (total, item) => total + ((item['quantity'] ?? 0) as int),
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          titleSpacing: 2,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 8, right: 15),
                  // Reduced left margin
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearch,
                      decoration: InputDecoration(
                        hintText: 'Search Amazon.in!',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () => navigateToSearch(""),
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Badge.count(
                    count: totalQuantity,
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Stars(rating: averageRating),
                  ],
                ),
              ),
              CarouselSlider(
                items: widget.product.images.map((i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 300,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/default.jpg", // your fallback image
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  );
                }).toList(),
                options: CarouselOptions(viewportFraction: 1, height: 200),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Deal Price: ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '\$${widget.product.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Text(widget.product.description),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomElevatedbutton(
                  text: 'Buy Now',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AddressScreen.routeName,
                      arguments: widget.product.price.toString(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomElevatedbutton(
                  text: 'Add to Cart',
                  onPressed: addToCart,
                  color: Colors.deepOrangeAccent,
                ),
              ),
          
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Rate The Product',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              RatingBar.builder(
                initialRating: myrating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: GlobalVariables.secondaryColor),
                onRatingUpdate: (rating) {
                  productDetailsService.rateProducts(
                    context: context,
                    product: widget.product,
                    rating: rating,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
