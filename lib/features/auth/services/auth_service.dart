import 'dart:convert';

import 'package:amazon_flutter_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_flutter_clone/constants/error_handling.dart';
import 'package:amazon_flutter_clone/constants/global_variables.dart';
import 'package:amazon_flutter_clone/constants/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

import '../../../providers/user_provider.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Account created! Login with same credentials');

          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
                (route) => false,
          );
          // NOTE: No navigation happens here - user needs to manually switch to login
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final requestBody = jsonEncode({'email': email, 'password': password});

      http.Response res = await http.post(
        Uri.parse('$uri/api/login'),
        body: requestBody,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          try {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();

            Provider.of<UserProvider>(context, listen: false).setUser(res.body);

            final token = jsonDecode(res.body)['token'];

            await sharedPreferences.setString('x-auth-token', token);

            Navigator.pushNamedAndRemoveUntil(
              context,
              BottomBar.routeName,
              (route) => false,
            );
          } catch (e) {}
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void getUserData({required BuildContext context}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? token = sharedPreferences.getString('x-auth-token');

      if (token == null) {
        sharedPreferences.setString('x-auth-token', '');
        return;
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userResponse = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userResponse.body);
      } else {}
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
