import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:payment_app/auth/screens/login.dart';
import 'package:payment_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    Future.delayed(const Duration(seconds: 2), () async {
      final username = await _getDataFromSharedPreferences("username");
      final terminal = await _getDataFromSharedPreferences("terminal");
      final password = await _getDataFromSharedPreferences("password");
      final productIDs = await loadListFromPrefs('productIds');
      final productNames = await loadListFromPrefs('productNames');
      log(terminal.toString());
      log(username.toString());
      log(password.toString());
      log(productIDs.toString());

      if (username != null && terminal != null || password != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(
                  terminalSerialNo: terminal!,
                  userCode: username!,
                  userPassword: password!,
                  ids: productIDs,
                  names: productNames,
                )));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  Future<String?> _getDataFromSharedPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<List<String>> loadListFromPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
