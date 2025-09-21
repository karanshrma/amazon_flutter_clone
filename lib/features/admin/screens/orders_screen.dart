import 'package:amazon_flutter_clone/common/widgets/loader.dart';
import 'package:amazon_flutter_clone/features/account/widgets/single_product.dart';
import 'package:amazon_flutter_clone/features/admin/services/admin_service.dart';
import 'package:amazon_flutter_clone/features/order_details/screens/order_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  final AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    print('[OrdersScreen] initState called');
    fetchAllOrders();
  }

  void fetchAllOrders() async {
    print('[OrdersScreen] Fetching all orders...');
    try {
      orders = await adminService.fetchAllOrders(context);
      print('[OrdersScreen] Orders fetched successfully: '
          '${orders.length} found');
    } catch (e, st) {
      print('[OrdersScreen] Error fetching orders: $e');
      print(st);
    }
    setState(() {
      print('[OrdersScreen] setState called after fetching orders');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('[OrdersScreen] build called - orders: ${orders?.length ?? "null"}');
    return orders.isEmpty
        ? const Center(
      child: Text('Customer has not placed any orders yet'),
    )
        : GridView.builder(
      itemCount: orders!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        final orderData = orders![index];
        print(
            '[OrdersScreen] Building order tile for index $index, orderId: ${orderData.id}');
        return GestureDetector(
          onTap: () {
            print(
                '[OrdersScreen] Order tapped at index $index, navigating to details');
            Navigator.pushNamed(
              context,
              OrderDetailsScreen.routeName,
              arguments: orderData,
            );
          },
          child: SizedBox(
            height: 140,
            child: SingleProduct(
              image: orderData.products[0].images[0],
            ),
          ),
        );
      },
    );
  }
}
