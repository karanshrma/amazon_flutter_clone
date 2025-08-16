import 'package:amazon_flutter_clone/constants/utils.dart';
import 'package:amazon_flutter_clone/features/account/services/account_service.dart';
import 'package:amazon_flutter_clone/features/account/widgets/account_button.dart';
import 'package:amazon_flutter_clone/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your Orders', onTap: (){}),
            AccountButton(text: 'Turn Seller', onTap: (){})
          ],
        ),
        const SizedBox(height: 6),
        Row(children: [
          AccountButton(text: 'Log Out', onTap: () => AccountService().logout(context)),
          AccountButton(text: 'Your Wishlist', onTap: (){})
        ]),
      ],
    );
  }
}
