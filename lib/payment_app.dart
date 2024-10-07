import 'package:flutter/material.dart';
import 'package:payment_app/controller/deposit_payment_controller.dart';
import 'package:payment_app/controller/deposit_print_controller.dart';
import 'package:payment_app/controller/ledger_report_controller.dart';
import 'package:payment_app/controller/login_controller.dart';
import 'package:payment_app/controller/sales_report_controller.dart';
import 'package:payment_app/controller/ticket_payment_controller.dart';
import 'package:payment_app/controller/ticket_print_controller.dart';
import 'package:payment_app/controller/user_balance_controller.dart';
import 'package:payment_app/routes/routes.dart';
import 'package:provider/provider.dart';

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TicketPaymentController(),
        ),
        ChangeNotifierProvider(
          create: (context) => TicketPrintController(),
        ),
        ChangeNotifierProvider(
          create: (context) => DepositPaymentController(),
        ),
        ChangeNotifierProvider(
          create: (context) => DepositPrintController(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserBalanceController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesReportController(),
        ),
        ChangeNotifierProvider(
          create: (context) => LedgerReportController(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          return AppRouter.onGenerateRoute(settings);
        },
      ),
    );
  }
}
