import 'package:flutter/material.dart';
import 'package:payment_app/screens/splash.dart';

class AppRouter {
  static const String splash = "/";

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const Splash());

      default:
    }
    return null;
  }
}
