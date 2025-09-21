import 'dart:convert';
import 'dart:io';
import 'package:amazon_flutter_clone/constants/utils.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';
import '../models/sales.dart';

class AdminService {
  void sellProducts({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final cloudinary = CloudinaryPublic('dfpolwe00', 'unsigned_preset_karan');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {

        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(response.secureUrl);
      }
      if (imageUrls.isNotEmpty &&
          imageUrls.first.startsWith('https://images.unsplash.com')) {
        final migratedUrl =
        await cacheImageInCloudinary(imageUrls.first, 'imported');
        imageUrls[0] = migratedUrl;
      }


      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );



      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );




      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {

          showSnackbar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {

      showSnackbar(context, e.toString());
    }
  }

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {

      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );




      if (res.statusCode == 200) {
        var decodedResponse = jsonDecode(res.body) as List<dynamic>;


        for (int i = 0; i < decodedResponse.length; i++) {
          try {
            print("🔄 Processing product $i");
            Map<String, dynamic> productMap =
                decodedResponse[i] as Map<String, dynamic>;
            Product product = Product.fromMap(productMap);
            productList.add(product);
            print("✅ Successfully added product: ${product.name}");
          } catch (e) {
            print("❌ Error parsing product at index $i: $e");
            print("🔍 Product data: ${decodedResponse[i]}");
          }
        }

        print("✅ Successfully fetched ${productList.length} products");
      } else {
        print("❌ HTTP Error: ${res.statusCode}");
        showSnackbar(context, "Failed to fetch products: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Error in fetchAllProducts: $e");
      showSnackbar(context, e.toString());
    }
    return productList;
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      print("🟢 [fetchAllOrders] Fetching...");
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      print("📡 Response status: ${res.statusCode}");
      print("📡 Response body: ${res.body}");

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var decodedResponse = jsonDecode(res.body);
          print("📦 Decoded orders length: ${decodedResponse.length}");
          for (int i = 0; i < decodedResponse.length; i++) {
            // Fix: Use fromMap instead of fromJson, and cast to Map<String, dynamic>
            orderList.add(
              Order.fromMap(decodedResponse[i] as Map<String, dynamic>),
            );
          }
        },
      );
    } catch (e) {
      print("❌ Error in fetchAllOrders: $e");
      showSnackbar(context, e.toString());
    }
    return orderList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      print("🟢 [deleteProduct] Deleting product: ${product.id}");
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id}),
      );

      print("📡 Response status: ${res.statusCode}");
      print("📡 Response body: ${res.body}");

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print("✅ Product deleted successfully");
          onSuccess();
        },
      );
    } catch (e) {
      print("❌ Error in deleteProduct: $e");
      showSnackbar(context, e.toString());
    }
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      print(
        "🟢 [changeOrderStatus] Changing order: ${order.id} → status: $status",
      );
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status, // Fix: Include status in the body
        }),
      );

      print("📡 Response status: ${res.statusCode}");
      print("📡 Response body: ${res.body}");

      httpErrorHandle(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      print("❌ Error in changeOrderStatus: $e");
      showSnackbar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      print("🟢 [getEarnings] Fetching analytics...");
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      print("📡 Response status: ${res.statusCode}");
      print("📡 Response body: ${res.body}");

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          print("💰 Total earnings: $totalEarning");

          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
          print("📊 Sales breakdown: $sales");
        },
      );
    } catch (e) {
      print("❌ Error in getEarnings: $e");
      showSnackbar(context, e.toString());
    }
    return {'sales': sales, 'totalEarnings': totalEarning};
  }
  Future<String> cacheImageInCloudinary(String url, String folder) async {
    final cloud = CloudinaryPublic('dfpolwe00', 'unsigned_preset_karan');
    final res = await cloud.uploadFile(
      CloudinaryFile.fromUrl(url, folder: folder),
    );
    return res.secureUrl;
  }

}
