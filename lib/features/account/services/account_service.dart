import 'dart:convert';
import 'package:amazon_flutter_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/order.dart';
import '../../../providers/user_provider.dart';
import '../../auth/screens/auth_screen.dart';


class AccountService {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Fixed: Get the decoded response first
          var decodedResponse = jsonDecode(res.body);
          // Then iterate through the list length
          for (int i = 0; i < decodedResponse.length; i++) {
            orderList.add(Order.fromMap(decodedResponse[i] as Map<String , dynamic>));
          }
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return orderList;
  }

  void logout(BuildContext context) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(context, AuthScreen.routeName , (route) => false);
    } catch(e){
      showSnackbar(context, e.toString());
    }
  }


  Future<Product> fetchDealOfDay({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: 'name',
      description: 'description',
      quantity: 0,
      images: [],
      category: 'category',
      price: 0.0,
    );
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/deal-of-the-day'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return product;
  }
}
