import 'package:amazon_flutter_clone/common/widgets/loader.dart';
import 'package:amazon_flutter_clone/constants/global_variables.dart';
import 'package:amazon_flutter_clone/features/account/services/account_service.dart';
import 'package:amazon_flutter_clone/features/account/widgets/single_product.dart';
import 'package:amazon_flutter_clone/features/order_details/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountService accountService = AccountService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    await accountService.fetchMyOrders(context: context);
    setState(() {});
  }
  void navigateToOrdersDetails(Order order){
    Navigator.pushNamed(context, OrderDetailsScreen.routeName , arguments: order);
  }

  @override
  Widget build(BuildContext context) {
    if (orders == null || orders!.isEmpty) {
      return Center(child: Text('No orders yet'));
    }
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Your Orders',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 18,
                        color: GlobalVariables.selectedNavBarColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 170,
                padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: orders!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => navigateToOrdersDetails(orders![index]),
                      child: SingleProduct(
                        image: orders![index].products[0].images[0],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
