import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazon_flutter_clone/providers/user_provider.dart';
import '../../../common/widgets/custom_elevatedbutton.dart';
import '../../address/screens/address_screen.dart';

class CartLength extends StatelessWidget {
  const CartLength({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    int sum = 0;
    sum = user.cart.fold(0, (total, item) {
      final int quantity = (item['quantity'] ?? 0) as int;
      final int price = (item['product']['price'] ?? 0).toInt();
      final int subtotal = quantity * price;

      return total + subtotal;
    });
    int totalQuantity = user.cart.fold(
      0,
      (total, item) => total + ((item['quantity'] ?? 0) as int),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomElevatedbutton(
        color: Colors.yellow,
        text: 'Proceed to buy $totalQuantity items',
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddressScreen.routeName,
            arguments: sum.toString(),
          );
        },
      ),
    );
  }
}
