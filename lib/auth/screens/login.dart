import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:payment_app/auth/widgets/textfieldwidget.dart';
import 'package:payment_app/common/custombutton.dart';
import 'package:payment_app/controller/login_controller.dart';
import 'package:payment_app/screens/home.dart';
import 'package:payment_app/utils/mediaquery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

Future<void> _saveDataToSharedPreferences(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<void> _saveListDataToSharedPreferences(
    String key, List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final usernamelController = TextEditingController();
  final passwordController = TextEditingController();
  final terminalController = TextEditingController();
  // final notification = NotificationServices();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight(context) * 0.82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/a2z.png'),
                  Column(
                    children: [
                      TextFieldWidget(
                          controller: usernamelController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "username cant be empty";
                            }
                            return null;
                          },
                          hint: 'Enter username'),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "password cant be empty";
                          }
                          return null;
                        },
                        controller: passwordController,
                        hint: 'Enter password',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "terminal ID cant be empty";
                          }
                          return null;
                        },
                        controller: terminalController,
                        hint: 'Enter terminal ID',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      CustomButton(
                        enabledColor: Theme.of(context)
                            .primaryColor, // Button color when enabled
                        disabledColor: Colors.grey,
                        text: 'Log In',
                        isloading: isloading,
                        onTap: () async {
                          print('1');

                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            try {
                              await context
                                  .read<LoginController>()
                                  .getLoginData(
                                      username: usernamelController.text,
                                      password: passwordController.text,
                                      terminal: terminalController.text);

                              // ignore: use_build_context_synchronously

                              // await notification.requestPermission();
                              // // ignore: use_build_context_synchronously
                              // await notification.getToken(context);

                              // ignore: use_build_context_synchronously
                              if (context
                                      .read<LoginController>()
                                      .feedBackModel!
                                      .responseObject!
                                      .status ==
                                  true) {
                                await _saveDataToSharedPreferences(
                                    'username', usernamelController.text);
                                await _saveDataToSharedPreferences(
                                    'password', passwordController.text);

                                await _saveDataToSharedPreferences(
                                    'terminal', terminalController.text);
                                await _saveListDataToSharedPreferences(
                                    'productIds',
                                    context
                                        .read<LoginController>()
                                        .feedBackModel!
                                        .output!
                                        .map((e) => e.productId.toString())
                                        .toList());
                                await _saveListDataToSharedPreferences(
                                    'productNames',
                                    context
                                        .read<LoginController>()
                                        .feedBackModel!
                                        .output!
                                        .map((e) => e.productName.toString())
                                        .toList());

                                log('Data Saved');
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                              userCode:
                                                  usernamelController.text,
                                              terminalSerialNo:
                                                  terminalController.text,
                                              userPassword:
                                                  passwordController.text,
                                              ids: context
                                                  .read<LoginController>()
                                                  .feedBackModel!
                                                  .output!
                                                  .map((e) =>
                                                      e.productId.toString())
                                                  .toList(),
                                              names: context
                                                  .read<LoginController>()
                                                  .feedBackModel!
                                                  .output!
                                                  .map((e) =>
                                                      e.productName.toString())
                                                  .toList(),
                                            )));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: Colors.deepOrange,
                                  content: Text(context
                                      .read<LoginController>()
                                      .feedBackModel!
                                      .responseObject!
                                      .statusDetails
                                      .toString()),
                                ));
                              }

                              setState(() {
                                isloading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.deepOrange,
                                content: Text(
                                  e.toString(),
                                ),
                              ));
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        },
                      ),

                      // SizedBox(
                      //   width: double.infinity,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   const SignUpScreen()));
                      //     },
                      //     child: const Text(
                      //       'SignUp',
                      //       textAlign: TextAlign.end,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
