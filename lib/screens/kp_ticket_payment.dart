import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/auth/widgets/textfieldwidget.dart';
import 'package:payment_app/common/borderbutton.dart';
import 'package:payment_app/common/custombutton.dart';
import 'package:payment_app/controller/ticket_payment_controller.dart';
import 'package:payment_app/controller/ticket_print_controller.dart';
import 'package:payment_app/controller/user_balance_controller.dart';
import 'package:payment_app/screens/sales_report.dart';
import 'package:payment_app/utils/mediaquery.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KPTicketPayment extends StatefulWidget {
  const KPTicketPayment({super.key});

  @override
  State<KPTicketPayment> createState() => _KPTicketPaymentState();
}

Future<void> _saveDataToSharedPreferences(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

class _KPTicketPaymentState extends State<KPTicketPayment> {
  String? username;
  String? password;
  String? terminal;
  final formKey = GlobalKey<FormState>();
  final ticketController = TextEditingController();
  final amountController = TextEditingController();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  // final notification = NotificationServices();
  bool isloading = false;
  bool isloading2 = false;
  bool isloading3 = false;

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

  final ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text('KP Payment Ticket'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight(context) * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      TextFieldWidget(
                          controller: ticketController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "ticket cant be empty";
                            }
                            return null;
                          },
                          hint: 'Enter ticket number'),
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
                        hint: 'Enter amount',
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
                          text: 'Pay Ticket',
                          isloading: isloading,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isloading = true;
                                });
                                await context
                                    .read<TicketPaymentController>()
                                    .getTicketpaymentData(
                                      ticketNo:
                                          int.parse(ticketController.text),
                                      amount: amountController.text,
                                      username: username!,
                                      password: password!,
                                      terminal: terminal!,
                                    );
                                setState(() {
                                  isloading = false;
                                });
                                ticketController.clear();
                                amountController.clear();
                                // ignore: use_build_context_synchronously
                                if (context
                                        .read<TicketPaymentController>()
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
                                          .read<TicketPaymentController>()
                                          .feedBackModel!
                                          .output!
                                          .merchantBalance;
                                  final issueDate = DateTime.parse(context
                                      .read<TicketPaymentController>()
                                      .feedBackModel!
                                      .output!
                                      .issuanceDataTime!);
                                  final transactionDate = DateTime.parse(context
                                      .read<TicketPaymentController>()
                                      .feedBackModel!
                                      .output!
                                      .transactionTime!);
                                  final formattedGenerateDate =
                                      DateFormat('dd-MMM-yy hh:mm a')
                                          .format(issueDate);
                                  final formattedPaidDate =
                                      DateFormat('dd-MMM-yy hh:mm a')
                                          .format(transactionDate);
                                  // ignore: use_build_context_synchronously
                                  return showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                AlertDialog(
                                                  title: Center(
                                                    child: Image.asset(
                                                      'assets/images/checked.png',
                                                      height: 80,
                                                    ),
                                                  ),
                                                  content: Center(
                                                    child: Column(
                                                      children: [
                                                        Screenshot(
                                                          controller:
                                                              controller,
                                                          child: Container(
                                                            color: Colors
                                                                .white, // Set your desired background color
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    16.0), // Option
                                                            child: Column(
                                                              children: [
                                                                const Text(
                                                                  'Successfully Paid',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        'Issuance Date : $formattedGenerateDate'),
                                                                    Text(
                                                                        'Paid Date : $formattedPaidDate'),
                                                                    Text(
                                                                        'Merchant : ${context.read<TicketPaymentController>().feedBackModel!.output!.merchantName!}'),
                                                                    Text(
                                                                        'TO Name : ${context.read<TicketPaymentController>().feedBackModel!.output!.toName!}'),
                                                                    Text(
                                                                        'Ticket No # : ${context.read<TicketPaymentController>().feedBackModel!.output!.ticketNo.toString()}'),
                                                                    Text(
                                                                        'Offender : ${context.read<TicketPaymentController>().feedBackModel!.output!.offenderName.toString()}'),
                                                                    Text(
                                                                        'Total Amount : ${context.read<TicketPaymentController>().feedBackModel!.output!.totalAmount.toString()}'),
                                                                  ],
                                                                ),
                                                                const Text(
                                                                  'Status : Paid',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        CustomButton(
                                                          enabledColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          // textColor: Theme.of(
                                                          //         context)
                                                          //     .colorScheme
                                                          //     .primary,
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
                                                                      'Ticket Slip',
                                                                      4,
                                                                      1);

                                                              await printer
                                                                  .printCustom(
                                                                      'Issuance Date:$formattedGenerateDate',
                                                                      1,
                                                                      1);

                                                              await printer
                                                                  .printCustom(
                                                                      'Paid Date: $formattedPaidDate',
                                                                      1,
                                                                      0);
                                                              await printer
                                                                  .printCustom(
                                                                      'Merchant : ${context.read<TicketPaymentController>().feedBackModel!.output!.merchantName.toString()}',
                                                                      1,
                                                                      0);
                                                              await printer
                                                                  .printCustom(
                                                                      'TO Name: ${context.read<TicketPaymentController>().feedBackModel!.output!.toName.toString()}',
                                                                      1,
                                                                      0);

                                                              await printer
                                                                  .printCustom(
                                                                      'Ticket No# : ${context.read<TicketPaymentController>().feedBackModel!.output!.ticketNo.toString()}',
                                                                      1,
                                                                      0);

                                                              await printer
                                                                  .printCustom(
                                                                      'Offender : ${context.read<TicketPaymentController>().feedBackModel!.output!.offenderName.toString()}',
                                                                      1,
                                                                      0);
                                                              await printer
                                                                  .printCustom(
                                                                      'Total Amount : ${context.read<TicketPaymentController>().feedBackModel!.output!.totalAmount.toString()}',
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
                                                                      XFile.fromData(
                                                                          image,
                                                                          mimeType:
                                                                              'image/png'),
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
                                              ],
                                            ),
                                            Positioned(
                                              top: 15,
                                              right: 25,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Image.asset(
                                                  'assets/images/cancel.png',
                                                  height: 35,
                                                ),
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
                                                        TicketPaymentController>()
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
                                  .read<TicketPrintController>()
                                  .getTicketPrintData(
                                      password: password!,
                                      username: username!,
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
                                        .read<TicketPrintController>()
                                        .feedBackModel!
                                        .output !=
                                    null) {
                                  final generateDate = DateTime.parse(context
                                      .read<TicketPrintController>()
                                      .feedBackModel!
                                      .output!
                                      .issuanceDataTime!);
                                  final paidDate = DateTime.parse(context
                                      .read<TicketPrintController>()
                                      .feedBackModel!
                                      .output!
                                      .transactionTime!);
                                  final formattedGenerateDate =
                                      DateFormat('dd-MMM-yy hh:mm a')
                                          .format(generateDate);
                                  final formattedPaidDate =
                                      DateFormat('dd-MMM-yy hh:mm a')
                                          .format(paidDate);
                                  print('connected');
                                  printer.printNewLine();
                                  await printer.printCustom(
                                      'Ticket Slip', 4, 1);
                                  await printer.printCustom('(Reprint)', 1, 1);
                                  await printer.printNewLine();

                                  await printer.printCustom(
                                      'Issuance Date:$formattedGenerateDate',
                                      1,
                                      0);

                                  await printer.printCustom(
                                      'Paid Date:$formattedPaidDate', 1, 0);
                                  await printer.printCustom(
                                      'MerchantName: ${context.read<TicketPrintController>().feedBackModel!.output!.merchantName.toString()}',
                                      1,
                                      0);
                                  await printer.printCustom(
                                      'TOName: ${context.read<TicketPrintController>().feedBackModel!.output!.toName.toString()}',
                                      1,
                                      0);
                                  await printer.printCustom(
                                      'OffenderName: ${context.read<TicketPrintController>().feedBackModel!.output!.offenderName.toString()}',
                                      1,
                                      0);

                                  await printer.printCustom(
                                      'TotalAmount: ${context.read<TicketPrintController>().feedBackModel!.output!.totalAmount.toString()}',
                                      1,
                                      0);

                                  await printer.printCustom(
                                      'Status : Paid', 1, 0);
                                  // await printer
                                  //     .printImage('assets/images/checked.png');

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
                                          .read<TicketPrintController>()
                                          .feedBackModel!
                                          .responseObject!
                                          .status ==
                                      true &&
                                  context
                                          .read<TicketPrintController>()
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
                                                  .read<TicketPrintController>()
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
                              // else {
                              // ignore: use_build_context_synchronously
                              // return showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return Center(
                              //       child: Column(
                              //         mainAxisSize: MainAxisSize.min,
                              //         children: [
                              //           AlertDialog(
                              //             title: Center(
                              //               child: Image.asset(
                              //                 'assets/images/cancel.png',
                              //                 height: 100,
                              //               ),
                              //             ),
                              //             content: Center(
                              //               child: Text(context
                              //                   .read<TicketPrintController>()
                              //                   .feedBackModel!
                              //                   .responseObject!
                              //                   .statusDetails
                              //                   .toString()),
                              //             ),
                              //             // content: Text(
                              //             //   context
                              //             //       .read<TicketPrintController>()
                              //             //       .feedBackModel!
                              //             //       .output!
                              //             //       .toJson()
                              //             //       .toString(),
                              //             // ),
                              //             // title: Text(context
                              //             //     .read<TicketPaymentController>()
                              //             //     .feedBackModel!
                              //             //     .output!
                              //             //     .toString())
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              // );
                              // }
                            } catch (e) {
                              setState(() {
                                isloading2 = false;
                              });
                              print(e);
                            }
                          },
                          isloading: isloading2,
                          text: 'Print Ticket')
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
      ),
    );
  }
}
