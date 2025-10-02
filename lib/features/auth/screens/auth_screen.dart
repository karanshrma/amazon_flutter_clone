import 'package:amazon_flutter_clone/constants/global_variables.dart';
import 'package:amazon_flutter_clone/features/auth/services/auth_service.dart';
import 'package:amazon_flutter_clone/common/widgets/custom_elevatedbutton.dart';
import 'package:flutter/material.dart';

import '../../../constants/utils.dart';
import '../widgets/custom_textfield.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signupFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  void signupUser() {
    try {
      authService.signUpUser(
        context: context,
        name: textEditingController.text,
        email: emailEditingController.text,
        password: passwordEditingController.text,
      );
      showSnackbar(context, 'Account created! Click on Login!');
    } catch (e) {
      print(e.toString());
    }
  }

  void loginUser() {
    try {
      authService.loginUser(
        context: context,
        email: emailEditingController.text,
        password: passwordEditingController.text,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    passwordEditingController.dispose();
    emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              ListTile(
                tileColor: _auth == Auth.signup
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.backgroundColor,
                title: const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signup,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signup)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    right: 18.0,
                    bottom: 10,
                  ),
                  child: Form(
                    key: _signupFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        CustomTextfield(
                          iconData: Icon(Icons.person),
                          controller: textEditingController,
                          hintText: 'Enter your name',
                          validator: (value) {
                            print(
                              'Name validation: ${value?.isEmpty ?? true ? 'FAILED' : 'PASSED'}',
                            );
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        CustomTextfield(
                          iconData: Icon(Icons.alternate_email),
                          controller: emailEditingController,
                          hintText: 'Enter your email',
                          validator: (value) {
                            print(
                              ' Email validation: ${value?.isEmpty ?? true ? 'FAILED' : 'PASSED'}',
                            );
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        CustomTextfield(
                          iconData: Icon(Icons.password_rounded),
                          controller: passwordEditingController,
                          hintText: 'Enter your password',
                          obscureText: false,
                          validator: (value) {
                            print(
                              'Password validation: ${value?.isEmpty ?? true ? 'FAILED' : 'PASSED'}',
                            );
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: CustomElevatedbutton(
                            text: 'Sign Up',
                            onPressed: () {
                              if (_signupFormKey.currentState!.validate()) {
                                signupUser();
                              } else {}
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ListTile(
                tileColor: _auth == Auth.signin
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.backgroundColor,
                title: const Text(
                  'Log In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signin,
                  groupValue: _auth,
                  onChanged: (Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signin)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    right: 18.0,
                    bottom: 10,
                  ),
                  child: Form(
                    key: _signinFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        CustomTextfield(
                          iconData: Icon(Icons.alternate_email),
                          controller: emailEditingController,
                          hintText: 'Enter your email',
                          validator: (value) {
                            print(
                              ' Email validation: ${value?.isEmpty ?? true ? 'FAILED' : 'PASSED'}',
                            );
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        CustomTextfield(
                          iconData: Icon(Icons.password_rounded),
                          controller: passwordEditingController,
                          hintText: 'Enter your password',
                          obscureText: false,
                          validator: (value) {
                            print(
                              ' Password validation: ${value?.isEmpty ?? true ? 'FAILED' : 'PASSED'}',
                            );
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: CustomElevatedbutton(
                            text: 'Log In',
                            onPressed: () {
                              if (_signinFormKey.currentState!.validate()) {
                                loginUser();
                              } else {}
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
