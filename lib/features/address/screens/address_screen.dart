import 'package:amazon_flutter_clone/constants/utils.dart';
import 'package:amazon_flutter_clone/features/address/services/address_service.dart';
import 'package:amazon_flutter_clone/features/cart/services/cart_service.dart';
import 'package:amazon_flutter_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Add this import for rootBundle
import '../../../constants/global_variables.dart';
import '../../auth/widgets/custom_textfield.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address-screen';

  const AddressScreen({super.key, required this.totalAmount});

  final String totalAmount;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addresskey = GlobalKey<FormState>();
  final CartService cartService = CartService();
  String addressToBeUsed = "";
  final AddressService addressService = AddressService();

  List<PaymentItem> paymentitem = [];

  void onGpayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address.isEmpty) {
      addressService.saveUserAddress(
        context: context,
        address: addressToBeUsed,
      );
    }
    addressService.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: widget.totalAmount as double,
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm =
        flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addresskey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    }

  }

  @override
  void initState() {
    super.initState();
    paymentitem = [
      PaymentItem(
        label: 'Total Amount',
        amount: widget.totalAmount.toString(),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  // // Add this method to load the configuration
  Future<PaymentConfiguration> _loadPaymentConfiguration() async {
    final String configString = await rootBundle.loadString('assets/gpay.json');
    return PaymentConfiguration.fromJsonString(configString);
  }

  @override
  Widget build(BuildContext context) {
    // var address = '101 Fake Street';
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (address.isNotEmpty)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('OR', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _addresskey,
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    CustomTextfield(
                      iconData: Icon(Icons.person),
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your flat/house no./building';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    CustomTextfield(
                      iconData: Icon(Icons.alternate_email),
                      controller: areaController,
                      hintText: 'Area, Street',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your area';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),

                    CustomTextfield(
                      iconData: Icon(Icons.password_rounded),
                      controller: pincodeController,
                      hintText: 'Pincode',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your pincode';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),

                    CustomTextfield(
                      iconData: Icon(Icons.password_rounded),
                      controller: cityController,
                      hintText: 'Town/City',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your town/city';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            FutureBuilder<PaymentConfiguration>(
              future: _loadPaymentConfiguration(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GooglePayButton(
                    width: double.infinity,
                    onPressed: () => payPressed(address),

                    paymentItems: paymentitem,
                    paymentConfiguration: snapshot.data!,
                    type: GooglePayButtonType.pay,
                    margin: const EdgeInsets.only(top: 15.0),
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }
}
