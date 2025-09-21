import 'package:amazon_flutter_clone/features/account/services/account_service.dart';
import 'package:amazon_flutter_clone/features/account/widgets/account_button.dart';
import 'package:amazon_flutter_clone/features/cart/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your Orders', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()))),
          ],
        ),
        const SizedBox(height: 6),
        Row(children: [
          AccountButton(text: 'Log Out', onTap: () => AccountService().logout(context)),
        ]),
      ],
    );
  }
}
