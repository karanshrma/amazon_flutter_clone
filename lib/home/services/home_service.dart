import 'dart:convert';
import 'package:amazon_flutter_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../constants/error_handling.dart';
import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
import '../../providers/user_provider.dart';

class HomeService {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var decodedResponse = jsonDecode(res.body);
          for (int i = 0; i < decodedResponse.length; i++) {
            productList.add(Product.fromMap(decodedResponse[i] as Map<String, dynamic>));
          }
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
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
