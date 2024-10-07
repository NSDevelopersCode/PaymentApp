import 'package:flutter/material.dart';
import 'package:payment_app/auth/screens/login.dart';
import 'package:payment_app/common/custombutton.dart';
import 'package:payment_app/controller/user_balance_controller.dart';
import 'package:payment_app/screens/deposit_slip_payment.dart';
import 'package:payment_app/screens/kp_ticket_payment.dart';
import 'package:payment_app/screens/ledger_report.dart';
import 'package:payment_app/screens/sales_report.dart';
import 'package:payment_app/utils/mediaquery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required this.terminalSerialNo,
      required this.userCode,
      required this.userPassword,
      required this.ids,
      required this.names});
  final String userCode;
  final String userPassword;
  final String terminalSerialNo;
  final List<String> ids;
  final List<String> names;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<void> _clearDataFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('username');
  prefs.remove('terminal');
  prefs.remove('password');
}

class _HomeScreenState extends State<HomeScreen> {
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBalanceController>().getUserBalanceData(
          username: widget.userCode,
          password: widget.userPassword,
          terminal: widget.terminalSerialNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _clearDataFromSharedPreferences().then((value) {
                  context.read<UserBalanceController>().feedBackModel = null;
                  return Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                });
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Payment App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          height: screenHeight(context) * 0.62,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              // ElevatedButton(
              //   onPressed: () async {
              //     await context
              //         .read<UserBalanceController>()
              //         .getUserBalanceData(
              //           username: widget.userCode,
              //           password: widget.userPassword,
              //           terminal: widget.terminalSerialNo,
              //         );
              //   },
              //   child: const Text('TEST'),
              // ),
              context.watch<UserBalanceController>().feedBackModel != null &&
                      context
                              .watch<UserBalanceController>()
                              .feedBackModel!
                              .outputBalance !=
                          null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context
                              .watch<UserBalanceController>()
                              .feedBackModel!
                              .outputBalance!
                              .accountTitle
                              .toString(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // 'ID : ${context.watch<UserBalanceController>().feedBackModel!.outputBalance!.accountId.toString()}',
                              'ID : ${widget.userCode}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Balance : ${context.watch<UserBalanceController>().feedBackModel!.outputBalance!.balance.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    )
                  : const CircularProgressIndicator(),
              CustomButton(
                  enabledColor: Theme.of(context).primaryColor,
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const KPTicketPayment(),
                      ),
                    );
                  },
                  isloading: isloading,
                  text: 'KP Ticket Payment'),
              // CustomButton(
              //     onTap: () {}, isloading: false, text: 'KP DL Payment'),
              CustomButton(
                  enabledColor: Theme.of(context).primaryColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DepositSlipPayment(),
                      ),
                    );
                  },
                  isloading: false,
                  text: 'Bank Deposit Slip'),
              CustomButton(
                  enabledColor: Theme.of(context).primaryColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SalesRport(
                          username: widget.userCode,
                          password: widget.userPassword,
                          terminal: widget.terminalSerialNo,
                          ids: widget.ids,
                          names: widget.names,
                        ),
                      ),
                    );
                  },
                  isloading: false,
                  text: 'Sales Report'),
              CustomButton(
                  enabledColor: Theme.of(context).primaryColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LedgerReport(
                          username: widget.userCode,
                          password: widget.userPassword,
                          terminal: widget.terminalSerialNo,
                          ids: widget.ids,
                        ),
                      ),
                    );
                  },
                  isloading: false,
                  text: 'POS Ledger Report')
            ],
          ),
        ),
      ),
    );
  }
}
