import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/auth/widgets/textfieldwidget.dart';
import 'package:payment_app/common/borderbutton.dart';
import 'package:payment_app/common/custombutton.dart';
import 'package:payment_app/controller/deposit_payment_controller.dart';
import 'package:payment_app/controller/deposit_print_controller.dart';
import 'package:payment_app/controller/user_balance_controller.dart';
import 'package:payment_app/screens/sales_report.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepositSlipPayment extends StatefulWidget {
  const DepositSlipPayment({super.key});

  @override
  State<DepositSlipPayment> createState() => _DepositSlipPaymentState();
}

Future<void> _saveDataToSharedPreferences(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

class _DepositSlipPaymentState extends State<DepositSlipPayment> {
  String? username;
  String? password;
  String? terminal;
  final formKey = GlobalKey<FormState>();
  final depositSlipID = TextEditingController();
  final amountController = TextEditingController();
  final noOfTicketsController = TextEditingController();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  final ScreenshotController controller = ScreenshotController();

  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  // final notification = NotificationServices();
  bool isloading = false;
  bool isloading2 = false;
  bool isloading3 = false;
  bool isloading4 = false;

  @override
  void initState() {
    getUsernamepasswordAndTerminal();
    getDevices();
    super.initState();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    print('object');
    setState(() {});
  }

  Future<void> getUsernamepasswordAndTerminal() async {
    username = await _getDataFromSharedPreferences("username");
    password = await _getDataFromSharedPreferences("password");
    terminal = await _getDataFromSharedPreferences("terminal");
  }

  Future<String?> _getDataFromSharedPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Deposit Slip'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(''),
                    TextFieldWidget(
                        controller: depositSlipID,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ticket cant be empty";
                          }
                          return null;
                        },
                        hint: 'Enter Deposit Slip Number'),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldWidget(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "amount cant be empty";
                        }
                        return null;
                      },
                      controller: amountController,
                      hint: 'Enter Amount',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldWidget(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "amount cant be empty";
                        }
                        return null;
                      },
                      controller: noOfTicketsController,
                      hint: 'Enter No of Tickets',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    CustomButton(
                        enabledColor: Theme.of(context).colorScheme.primary,
                        text: 'Pay Deposit Slip',
                        isloading: isloading,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isloading = true;
                              });
                              await context
                                  .read<DepositPaymentController>()
                                  .getDepositPaymentData(
                                    depositSlipID:
                                        int.parse(depositSlipID.text),
                                    amount: amountController.text,
                                    noOfTickets: noOfTicketsController.text,
                                    username: username!,
                                    password: password!,
                                    terminal: terminal!,
                                  );
                              setState(() {
                                isloading = false;
                              });
                              depositSlipID.clear();
                              amountController.clear();
                              noOfTicketsController.clear();
                              // ignore: use_build_context_synchronously
                              if (context
                                      .read<DepositPaymentController>()
                                      .feedBackModel!
                                      .responseObject!
                                      .status ==
                                  true) {
                                context
                                        .read<UserBalanceController>()
                                        .feedBackModel!
                                        .outputBalance!
                                        .balance =
                                    context
                                        .read<DepositPaymentController>()
                                        .feedBackModel!
                                        .output!
                                        .merchantBalance;

                                final generateDate = DateTime.parse(context
                                    .read<DepositPaymentController>()
                                    .feedBackModel!
                                    .output!
                                    .generateDataTime!);
                                final paidDate = DateTime.parse(context
                                    .read<DepositPaymentController>()
                                    .feedBackModel!
                                    .output!
                                    .paidDataTime!);
                                final formattedGenerateDate =
                                    DateFormat('dd-MMM-yy hh:mm a')
                                        .format(generateDate);
                                final formattedPaidDate =
                                    DateFormat('dd-MMM-yy hh:mm a')
                                        .format(paidDate);
                                // ignore: use_build_context_synchronously
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Screenshot(
                                            controller: controller,
                                            child: AlertDialog(
                                              title: Center(
                                                child: Image.asset(
                                                  'assets/images/checked.png',
                                                  height: 80,
                                                ),
                                              ),
                                              content: Center(
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      'Successfully Paid',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            'Generate Date : $formattedGenerateDate'),
                                                        Text(
                                                            'Paid Date : $formattedPaidDate'),
                                                        Text(
                                                            'Merchant : ${context.read<DepositPaymentController>().feedBackModel!.output!.merchantName!}'),
                                                        Text(
                                                            'TO Name : ${context.read<DepositPaymentController>().feedBackModel!.output!.toName!}'),
                                                        Text(
                                                            'Slip No# : ${context.read<DepositPaymentController>().feedBackModel!.output!.depositId.toString()}'),
                                                        Text(
                                                            'Tickets : ${context.read<DepositPaymentController>().feedBackModel!.output!.noOfTickets.toString()}'),
                                                        Text(
                                                            'Total Amount : ${context.read<DepositPaymentController>().feedBackModel!.output!.totalAmount.toString()}'),
                                                      ],
                                                    ),
                                                    const Text(
                                                      'Status : Paid',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Column(
                                                      children: [
                                                        CustomButton(
                                                          isloading: isloading3,
                                                          onTap: () async {
                                                            setState(() {
                                                              isloading3 = true;
                                                            });
                                                            if (selectedDevice !=
                                                                null) {
                                                              if (!(await printer
                                                                  .isConnected)!) {
                                                                await printer
                                                                    .connect(
                                                                        selectedDevice!);
                                                              }
                                                            }
                                                            // }

                                                            const SizedBox(
                                                              height: 10,
                                                            );

                                                            if ((await printer
                                                                .isConnected)!) {
                                                              print(
                                                                  'connected');
                                                              setState(() {
                                                                isloading3 =
                                                                    false;
                                                              });
                                                              printer
                                                                  .printNewLine();
                                                              await printer
                                                                  .printCustom(
                                                                      'Deposit Slip',
                                                                      4,
                                                                      1);

                                                              await printer
                                                                  .printCustom(
                                                                      'Generate Date:$formattedGenerateDate',
                                                                      1,
                                                                      1);

                                                              await printer
                                                                  .printCustom(
                                                                      'Paid Date: $formattedPaidDate',
                                                                      1,
                                                                      0);
                                                              await printer
                                                                  .printCustom(
                                                                      'Merchant : ${context.read<DepositPaymentController>().feedBackModel!.output!.merchantName.toString()}',
                                                                      1,
                                                                      0);
                                                              await printer
                                                                  .printCustom(
                                                                      'TO Name: ${context.read<DepositPaymentController>().feedBackModel!.output!.toName.toString()}',
                                                                      1,
                                                                      0);

                                                              await printer
                                                                  .printCustom(
                                                                      'Slip No# : ${context.read<DepositPaymentController>().feedBackModel!.output!.depositId.toString()}',
                                                                      1,
                                                                      0);

                                                              await printer
                                                                  .printCustom(
                                                                      'Tickets : ${context.read<DepositPaymentController>().feedBackModel!.output!.noOfTickets.toString()}',
                                                                      1,
                                                                      0);
                                                              await printer
                                                                  .printCustom(
                                                                      'Total Amount : ${context.read<DepositPaymentController>().feedBackModel!.output!.totalAmount.toString()}',
                                                                      1,
                                                                      0);
                                                              await printer
                                                                  .printCustom(
                                                                      'Status : Paid',
                                                                      1,
                                                                      0);
                                                              // printer.printQRcode('textToQR', 200, 200, 1);
                                                              printer
                                                                  .printNewLine();
                                                              printer
                                                                  .printNewLine();
                                                            } else {
                                                              setState(() {
                                                                isloading3 =
                                                                    false;
                                                              });
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text('bluetooth Device Not Connect')));
                                                            }
                                                          },
                                                          text: 'Print ?',
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        BorderButton(
                                                            onTap: () async {
                                                              try {
                                                                final image =
                                                                    await controller
                                                                        .capture();
                                                                if (image !=
                                                                    null) {
                                                                  log('Image captured successfully');
                                                                  Share
                                                                      .shareXFiles(
                                                                    [
                                                                      XFile
                                                                          .fromData(
                                                                        image,
                                                                        mimeType:
                                                                            'image/png',
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else {
                                                                  log('Failed to capture image');
                                                                }
                                                              } catch (e) {
                                                                log('Error during capture: $e');
                                                              }
                                                            },
                                                            isloading: false,
                                                            text: 'Share')
                                                        // CustomButton(
                                                        //     onTap: () {},
                                                        //     isloading: isloading4,
                                                        //     text: 'Connect'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // content: Text(
                                              //   context
                                              //       .read<TicketPrintController>()
                                              //       .feedBackModel!
                                              //       .output!
                                              //       .toJson()
                                              //       .toString(),
                                              // ),
                                              // title: Text(context
                                              //     .read<TicketPaymentController>()
                                              //     .feedBackModel!
                                              //     .output!
                                              //     .toString())
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                // ignore: use_build_context_synchronously
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AlertDialog(
                                            title: Center(
                                              child: Image.asset(
                                                'assets/images/cancel.png',
                                                height: 100,
                                              ),
                                            ),
                                            content: Center(
                                              child: Text(context
                                                  .read<
                                                      DepositPaymentController>()
                                                  .feedBackModel!
                                                  .responseObject!
                                                  .statusDetails
                                                  .toString()),
                                            ),
                                            // content: Text(
                                            //   context
                                            //       .read<TicketPrintController>()
                                            //       .feedBackModel!
                                            //       .output!
                                            //       .toJson()
                                            //       .toString(),
                                            // ),
                                            // title: Text(context
                                            //     .read<TicketPaymentController>()
                                            //     .feedBackModel!
                                            //     .output!
                                            //     .toString())
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    BorderButton(
                        onTap: () async {
                          try {
                            setState(() {
                              isloading2 = true;
                            });
                            await context
                                .read<DepositPrintController>()
                                .getDepositPrintData(
                                    username: username!,
                                    password: password!,
                                    terminal: terminal!);

                            print('object');

                            // if (!(await printer.isAvailable)!) {
                            //   print('text');
                            if (selectedDevice != null) {
                              if (!(await printer.isConnected)!) {
                                await printer.connect(selectedDevice!);
                              }
                            }
                            // }

                            const SizedBox(
                              height: 10,
                            );

                            if ((await printer.isConnected)!) {
                              if (context
                                      .read<DepositPrintController>()
                                      .feedBackModel!
                                      .output !=
                                  null) {
                                final generateDate = DateTime.parse(context
                                    .read<DepositPrintController>()
                                    .feedBackModel!
                                    .output!
                                    .generateDataTime!);
                                final paidDate = DateTime.parse(context
                                    .read<DepositPrintController>()
                                    .feedBackModel!
                                    .output!
                                    .paidDataTime!);
                                final formattedGenerateDate =
                                    DateFormat('dd-MMM-yy hh:mm a')
                                        .format(generateDate);
                                final formattedPaidDate =
                                    DateFormat('dd-MMM-yy hh:mm a')
                                        .format(paidDate);
                                print('connected');
                                printer.printNewLine();
                                await printer.printCustom('Deposit Slip', 4, 1);
                                await printer.printCustom('(Reprint)', 1, 1);
                                await printer.printNewLine();
                                await printer.printCustom(
                                    'Generate Date:$formattedGenerateDate',
                                    1,
                                    1);

                                await printer.printCustom(
                                    'Paid Date: $formattedPaidDate', 1, 0);
                                await printer.printCustom(
                                    'Merchant : ${context.read<DepositPrintController>().feedBackModel!.output!.merchantName.toString()}',
                                    1,
                                    0);
                                await printer.printCustom(
                                    'TO Name: ${context.read<DepositPrintController>().feedBackModel!.output!.toName.toString()}',
                                    1,
                                    0);

                                await printer.printCustom(
                                    'Slip No# : ${context.read<DepositPrintController>().feedBackModel!.output!.depositId.toString()}',
                                    1,
                                    0);

                                await printer.printCustom(
                                    'Tickets : ${context.read<DepositPrintController>().feedBackModel!.output!.noOfTickets.toString()}',
                                    1,
                                    0);
                                await printer.printCustom(
                                    'Total Amount : ${context.read<DepositPrintController>().feedBackModel!.output!.totalAmount.toString()}',
                                    1,
                                    0);
                                await printer.printCustom('Status: Paid', 1, 0);
                                // printer.printQRcode('textToQR', 200, 200, 1);

                                // printer.printQRcode('textToQR', 200, 200, 1);
                                printer.printNewLine();
                                printer.printNewLine();
                              } else {
                                context.showSnackBar('Output is empty',
                                    backgroundColor: Colors.red);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'bluetooth Device Not Connect')));
                            }
                            setState(() {
                              isloading2 = false;
                            });

                            // ignore: use_build_context_synchronously
                            if (context
                                        .read<DepositPrintController>()
                                        .feedBackModel!
                                        .responseObject!
                                        .status ==
                                    true &&
                                context
                                        .read<DepositPrintController>()
                                        .feedBackModel!
                                        .output !=
                                    null) {
                              // ignore: use_build_context_synchronously
                              return showDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AlertDialog(
                                          title: Center(
                                            child: Image.asset(
                                              'assets/images/checked.png',
                                              height: 100,
                                            ),
                                          ),
                                          content: Center(
                                            child: Text(context
                                                .read<DepositPrintController>()
                                                .feedBackModel!
                                                .responseObject!
                                                .statusDetails
                                                .toString()),
                                          ),
                                          // content: Text(
                                          //   context
                                          //       .read<DepositPrintController>()
                                          //       .feedBackModel!
                                          //       .output!
                                          //       .toJson()
                                          //       .toString(),
                                          // ),
                                          // title: Text(context
                                          //     .read<TicketPaymentController>()
                                          //     .feedBackModel!
                                          //     .output!
                                          //     .toString())
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                            //  else {
                            //   // ignore: use_build_context_synchronously
                            //   return showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return Center(
                            //         child: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             AlertDialog(
                            //               title: Center(
                            //                 child: Image.asset(
                            //                   'assets/images/canel.png',
                            //                   height: 100,
                            //                 ),
                            //               ),
                            //               content: Center(
                            //                 child: Text(context
                            //                     .read<DepositPrintController>()
                            //                     .feedBackModel!
                            //                     .responseObject!
                            //                     .statusDetails
                            //                     .toString()),
                            //               ),
                            //               // content: Text(
                            //               //   context
                            //               //       .read<DepositPrintController>()
                            //               //       .feedBackModel!
                            //               //       .output!
                            //               //       .toJson()
                            //               //       .toString(),
                            //               // ),
                            //               // title: Text(context
                            //               //     .read<TicketPaymentController>()
                            //               //     .feedBackModel!
                            //               //     .output!
                            //               //     .toString())
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   );
                            // }
                          } catch (e) {
                            setState(() {
                              isloading2 = false;
                            });
                            print(e);
                          }
                        },
                        isloading: isloading2,
                        text: 'Print Deposit Slip')
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
                    ,
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButton(
                      iconEnabledColor: Theme.of(context).primaryColor,
                      value: selectedDevice,
                      hint: const Text('Select Printer'),
                      items: devices
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name!),
                            ),
                          )
                          .toList(),
                      onChanged: (device) {
                        setState(() {
                          selectedDevice = device;
                          print(selectedDevice!.address);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
