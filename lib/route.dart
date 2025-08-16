import 'package:amazon_flutter_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_flutter_clone/models/order.dart';
import 'package:amazon_flutter_clone/models/product.dart';
import 'package:flutter/material.dart';

import 'common/widgets/bottom_bar.dart';
import 'features/address/screens/address_screen.dart';
import 'features/admin/screens/add_products.dart';
import 'features/order_details/screens/order_details_screen.dart';
import 'features/product_details/screens/product_details_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'home/screens/category_deals_screen.dart';
import 'home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routesettings) {
  switch (routesettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const BottomBar(),
      );
    case AddProducts.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const AddProducts(),
      );
    case SearchScreen.routeName:
      var searchQuery = routesettings.arguments as String;
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => SearchScreen(searchQuery: searchQuery),
      );

    case CategoryDealsScreen.routeName:
      var category = routesettings.arguments as String;
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => CategoryDealsScreen(category: category),
      );
    case ProductDetailsScreen.routeName:
      var product = routesettings.arguments as Product;
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => ProductDetailsScreen(product: product),
      );

    case AddressScreen.routeName:
      var totalAmount = routesettings.arguments as String;
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => AddressScreen(totalAmount: totalAmount),
      );
    case OrderDetailsScreen.routeName:
      var order = routesettings.arguments as Order;
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => OrderDetailsScreen(order: order),
      );

    default:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Screen does not exist'))),
      );
  }
}
