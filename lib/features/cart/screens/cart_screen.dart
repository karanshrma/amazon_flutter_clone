import 'package:amazon_flutter_clone/features/admin/services/admin_service.dart';
import 'package:amazon_flutter_clone/features/cart/widgets/cart_length.dart';
import 'package:amazon_flutter_clone/features/cart/widgets/cart_subtotal.dart';
import 'package:amazon_flutter_clone/home/widgets/address_box.dart';
import 'package:amazon_flutter_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/cart_product.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearch(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  // void navigateToAddress(int sum) {
  //   Navigator.pushNamed(
  //     context,
  //     AddressScreen.routeName,
  //     arguments: sum.toString(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final AdminService adminService = AdminService();
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          titleSpacing: 0,
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
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: OutlineInputBorder(
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: GestureDetector(
                            onTap: () => navigateToSearch,
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
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await adminService.fetchAllOrders(context);
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AddressBox(),
              const CartSubtotal(),
              const CartLength(),
              const SizedBox(height: 15),
              Container(color: Colors.white, height: 1),
              const SizedBox(height: 5),
              ...user.cart.asMap().entries.map((entry) {
                int index = entry.key;
                return CartProduct(index: index);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
