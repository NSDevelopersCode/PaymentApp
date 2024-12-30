import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/common/custombutton.dart';
import 'package:payment_app/controller/ledger_report_controller.dart';
import 'package:payment_app/model/ledger_report_model.dart';
import 'package:payment_app/screens/sales_report.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:screenshot/screenshot.dart';

class LedgerReport extends StatefulWidget {
  const LedgerReport(
      {super.key,
      required this.password,
      required this.terminal,
      required this.username,
      required this.ids});
  final String username;
  final String password;
  final String terminal;
  final List<String> ids;

  @override
  State<LedgerReport> createState() => _LedgerReportState();
}

class _LedgerReportState extends State<LedgerReport> {
  bool isloading = false;
  bool borderIsloading = false;
  DateTime? _fromSelectedDate = DateTime.now();
  DateTime? _toSelectedDate = DateTime.now();
  String formattedFromDate = '';
  String formattedToDate = '';
  List<OutputBalance>? outputBalances;
  final ScreenshotController controller = ScreenshotController();
  String productId = '';
  @override
  Widget build(BuildContext context) {
    bool isFirst = true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Ledger Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDatePickerField(
                  selectedDate: _fromSelectedDate,
                  title: "kamal",
                  initialDate: DateTime.now(),
                  onChanged: (date) {
                    setState(() {
                      _fromSelectedDate = date;
                    });
                    log(_fromSelectedDate.toString());
                    // viewModel.date.value = date!.toString();
                    // viewModel.initialDate.value = date;
                  },
                  hint: 'Select From Date',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomDatePickerField(
                  hint: 'Select To Date',
                  selectedDate: _toSelectedDate,
                  title: "kamal",
                  initialDate: DateTime.now(),
                  onChanged: (date) {
                    setState(() {
                      _toSelectedDate = date;
                    });
                    log(_toSelectedDate!.myDate.toString());
                    // viewModel.date.value = date!.toString();
                    // viewModel.initialDate.value = date;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                // Padding(
                //   padding: const EdgeInsets.only(right: 100),
                //   child: CustomDropdownFieldAgain(
                //     title: 'Select Product ID',
                //     value: productId,
                //     items: widget.ids,
                //     onChanged: (value) {
                //       log('value is $value');
                //       // viewModel.getCities(value);
                //       setState(() {
                //         productId = value!;
                //         // viewModel.driverName.value = value!;
                //         // _selectedDropdownValues[index] = value;
                //         // log('list is $_selectedDropdownValues');
                //       });
                //     },
                //   ),
                // ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    enabledColor: Theme.of(context)
                        .primaryColor, // Button color when enabled
                    disabledColor: Colors.grey,
                    onTap: _fromSelectedDate != null && _toSelectedDate != null
                        ? () async {
                            try {
                              setState(() {
                                isloading = true;
                              });
                              await context
                                  .read<LedgerReportController>()
                                  .getLedgerReportData(
                                    username: widget.username,
                                    password: widget.password,
                                    terminal: widget.terminal,
                                    fromDate: _fromSelectedDate.toString(),
                                    toDate: _toSelectedDate!.toString(),
                                  );
                              setState(() {
                                isloading = false;
                              });
                              if (context
                                          .read<LedgerReportController>()
                                          .feedBackModel!
                                          .responseObject!
                                          .status ==
                                      true &&
                                  context
                                          .read<LedgerReportController>()
                                          .feedBackModel!
                                          .outputBalance !=
                                      null) {
                                outputBalances = context
                                    .read<LedgerReportController>()
                                    .feedBackModel!
                                    .outputBalance!;
                                log(context
                                    .read<LedgerReportController>()
                                    .feedBackModel!
                                    .responseObject!
                                    .status
                                    .toString());
                                final entryDate = DateTime.parse(context
                                    .read<LedgerReportController>()
                                    .feedBackModel!
                                    .outputBalance![0]
                                    .entryDate!);

                                final formattedEntryDate =
                                    DateFormat('dd-MMM-yy hh:mm a')
                                        .format(entryDate);

                                formattedFromDate = DateFormat('dd-MMM-yy')
                                    .format(_fromSelectedDate!);
                                formattedToDate = DateFormat('dd-MMM-yy')
                                    .format(_toSelectedDate!);

                                // return showDialog(
                                //   barrierDismissible: false,
                                //   context: context,
                                //   builder: (context) {
                                //     return Builder(builder: (context) {
                                //       return Center(
                                //         child: Stack(
                                //           children: [
                                //             Column(
                                //               mainAxisSize: MainAxisSize.min,
                                //               children: [
                                //                 Screenshot(
                                //                   controller: controller,
                                //                   child: AlertDialog(
                                //                     actions: [
                                //                       CustomButton(
                                //                           enabledColor:
                                //                               Theme.of(context)
                                //                                   .colorScheme
                                //                                   .primary,
                                //                           onTap: () {},
                                //                           isloading: false,
                                //                           text: 'Print'),
                                //                       const SizedBox(
                                //                         height: 5,
                                //                       ),
                                //                       BorderButton(
                                //                           onTap: () async {
                                //                             try {
                                //                               final image =
                                //                                   await controller
                                //                                       .capture();
                                //                               if (image != null) {
                                //                                 log('Image captured successfully');
                                //                                 Share.shareXFiles(
                                //                                   [
                                //                                     XFile.fromData(
                                //                                         image,
                                //                                         mimeType:
                                //                                             'image/png'),
                                //                                   ],
                                //                                 );
                                //                               } else {
                                //                                 log('Failed to capture image');
                                //                               }
                                //                             } catch (e) {
                                //                               log('Error during capture: $e');
                                //                             }
                                //                           },
                                //                           isloading:
                                //                               borderIsloading,
                                //                           text: 'Share')
                                //                     ],
                                //                     title: Center(
                                //                       child: Image.asset(
                                //                         'assets/images/checked.png',
                                //                         height: 80,
                                //                       ),
                                //                     ),
                                //                     content: Center(
                                //                       child: Column(
                                //                         children: [
                                //                           // Text(
                                //                           //   context
                                //                           //       .read<LedgerReportController>()
                                //                           //       .feedBackModel!
                                //                           //       .outputBalance!
                                //                           //       .productName!,
                                //                           //   style: const TextStyle(
                                //                           //       fontSize: 18,
                                //                           //       fontWeight: FontWeight.bold),
                                //                           // ),
                                //                           const SizedBox(
                                //                             height: 5,
                                //                           ),
                                //                           Column(
                                //                             crossAxisAlignment:
                                //                                 CrossAxisAlignment
                                //                                     .start,
                                //                             children: [
                                //                               Text(
                                //                                   'Merchant : ${context.read<LedgerReportController>().feedBackModel!.responseObject!.merchantName!}'),
                                //                               // Text(
                                //                               //     'TotalTx : ${context.read<LedgerReportController>().feedBackModel!.outputBalance![1].totalTx!}'),

                                //                               Text(
                                //                                   'From Date : $formattedFromDate'),
                                //                               Text(
                                //                                   'To Date : $formattedToDate'),
                                //                               Text(
                                //                                   'Printed on : ${DateFormat('dd-MMM-yy hh:mm a').format(DateTime.now())}'),

                                //                               const Text(
                                //                                   '------------------------------------------------------------'),
                                //                               const Row(
                                //                                 mainAxisAlignment:
                                //                                     MainAxisAlignment
                                //                                         .spaceBetween,
                                //                                 children: [
                                //                                   Text('Date'),
                                //                                   Text('Amount'),
                                //                                   Text('Balance'),
                                //                                 ],
                                //                               ),
                                //                               const Text(
                                //                                   '------------------------------------------------------------'),
                                //                               Column(
                                //                                 children:
                                //                                     outputBalances
                                //                                         .map((e) {
                                //                                   final entryDate =
                                //                                       DateTime.parse(
                                //                                           e.entryDate!);
                                //                                   final formatEntryDate =
                                //                                       DateFormat(
                                //                                               'dd-MMM-yy')
                                //                                           .format(
                                //                                               entryDate);
                                //                                   return Row(
                                //                                     mainAxisAlignment:
                                //                                         MainAxisAlignment
                                //                                             .spaceBetween,
                                //                                     children: [
                                //                                       Text(
                                //                                           formatEntryDate),
                                //                                       Text(e
                                //                                           .amount!
                                //                                           .toString()),
                                //                                       Text(e
                                //                                           .currentBalance!
                                //                                           .toString()),
                                //                                     ],
                                //                                   );
                                //                                 }).toList(),
                                //                               ),
                                //                               const Text(
                                //                                   '------------------------------------------------------------'),
                                //                               // Text(
                                //                               //     'Current Balance : ${context.read<LedgerReportController>().feedBackModel!.outputBalance![1].currentBalance.toString()}'),
                                //                               // Text(
                                //                               //     'Total Amount : ${context.read<LedgerReportController>().feedBackModel!.outputBalance![1].amount.toString()}'),
                                //                               // Text(
                                //                               //     'Issuance Date : $formattedEntryDate'),
                                //                             ],
                                //                           ),
                                //                           const SizedBox(
                                //                             height: 10,
                                //                           ),
                                //                           // CustomButton(
                                //                           //   isloading: isloading3,
                                //                           //   onTap: () async {
                                //                           //     setState(() {
                                //                           //       isloading3 = true;
                                //                           //     });
                                //                           //     if (selectedDevice != null) {
                                //                           //       if (!(await printer.isConnected)!) {
                                //                           //         await printer
                                //                           //             .connect(selectedDevice!);
                                //                           //       }
                                //                           //     }
                                //                           //     // }

                                //                           //     const SizedBox(
                                //                           //       height: 10,
                                //                           //     );

                                //                           //     if ((await printer.isConnected)!) {
                                //                           //       print('connected');
                                //                           //       setState(() {
                                //                           //         isloading3 = false;
                                //                           //       });

                                //                           //       printer.printNewLine();

                                //                           //       await printer.printCustom(
                                //                           //           'Ticket Slip', 4, 1);

                                //                           //       await printer.printCustom(
                                //                           //           'Issuance Date:$formattedGenerateDate',
                                //                           //           1,
                                //                           //           1);

                                //                           //       await printer.printCustom(
                                //                           //           'Paid Date: $formattedPaidDate',
                                //                           //           1,
                                //                           //           0);
                                //                           //       await printer.printCustom(
                                //                           //           'Merchant : ${context.read<TicketPaymentController>().feedBackModel!.output!.merchantName.toString()}',
                                //                           //           1,
                                //                           //           0);
                                //                           //       await printer.printCustom(
                                //                           //           'TO Name: ${context.read<TicketPaymentController>().feedBackModel!.output!.toName.toString()}',
                                //                           //           1,
                                //                           //           0);

                                //                           //       await printer.printCustom(
                                //                           //           'Slip No# : ${context.read<TicketPaymentController>().feedBackModel!.output!.ticketId.toString()}',
                                //                           //           1,
                                //                           //           0);

                                //                           //       await printer.printCustom(
                                //                           //           'Offender : ${context.read<TicketPaymentController>().feedBackModel!.output!.offenderName.toString()}',
                                //                           //           1,
                                //                           //           0);
                                //                           //       await printer.printCustom(
                                //                           //           'Total Amount : ${context.read<TicketPaymentController>().feedBackModel!.output!.ticketAmount.toString()}',
                                //                           //           1,
                                //                           //           0);
                                //                           //       await printer.printCustom(
                                //                           //           'Status : Paid', 1, 0);
                                //                           //       // printer.printQRcode('textToQR', 200, 200, 1);
                                //                           //       printer.printNewLine();
                                //                           //       printer.printNewLine();
                                //                           //     } else {
                                //                           //       setState(() {
                                //                           //         isloading3 = false;
                                //                           //       });
                                //                           //       ScaffoldMessenger.of(context)
                                //                           //           .showSnackBar(const SnackBar(
                                //                           //               content: Text(
                                //                           //                   'bluetooth Device Not Connect')));
                                //                           //     }
                                //                           //   },
                                //                           //   text: 'Print ?',
                                //                           // ),
                                //                         ],
                                //                       ),
                                //                     ),
                                //                     // content: Text(
                                //                     //   context
                                //                     //       .read<TicketPrintController>()
                                //                     //       .feedBackModel!
                                //                     //       .output!
                                //                     //       .toJson()
                                //                     //       .toString(),
                                //                     // ),
                                //                     // title: Text(context
                                //                     //     .read<TicketPaymentController>()
                                //                     //     .feedBackModel!
                                //                     //     .output!
                                //                     //     .toString())
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //             Positioned(
                                //               top: 15,
                                //               right: 25,
                                //               child: GestureDetector(
                                //                 onTap: () {
                                //                   Navigator.pop(context);
                                //                 },
                                //                 child: Image.asset(
                                //                   'assets/images/cancel.png',
                                //                   height: 35,
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       );
                                //     });
                                //   },
                                // );
                              } else {
                                context.showSnackBar('Output Is Empty',
                                    backgroundColor: Colors.red);
                              }
                            } catch (e) {
                              log(e.toString());
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        : null,
                    isloading: isloading,
                    text: 'Get Ledger Report'),
                const SizedBox(
                  height: 10,
                ),
                outputBalances != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Screenshot(
                            controller: controller,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Merchant : ${context.read<LedgerReportController>().feedBackModel!.responseObject!.merchantName!}'),
                                  // Text(
                                  //     'TotalTx : ${context.read<LedgerReportController>().feedBackModel!.outputBalance![1].totalTx!}'),

                                  Text('From Date : $formattedFromDate'),
                                  Text('To Date :     $formattedToDate'),
                                  Text(
                                      'Printed on : ${DateFormat('dd-MMM-yy hh:mm a').format(DateTime.now())}'),

                                  const Text(
                                    '------------------------------------------------------------------------------------',
                                    maxLines: 1,
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '           Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Balance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),

                                  const Text(
                                    '------------------------------------------------------------------------------------',
                                    maxLines: 1,
                                  ),

                                  Column(
                                    children: outputBalances!.map((e) {
                                      final entryDate =
                                          DateTime.parse(e.entryDate!);
                                      final formatEntryDate =
                                          DateFormat('dd-MMM-yy')
                                              .format(entryDate);
                                      final myDate = e.particulars == 'Opening'
                                          ? '              '
                                          : formatEntryDate;
                                      final displayAmount =
                                          e.particulars == 'Opening'
                                              ? "Opening"
                                              : e.amount!.toString();
                                      isFirst = false;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(myDate),
                                          Text(displayAmount),
                                          Text(e.currentBalance!.toString()),
                                        ],
                                      );
                                    }).toList(),
                                  ),

                                  const Text(
                                    '------------------------------------------------------------------------------------',
                                    maxLines: 1,
                                  ),

                                  // Text(
                                  //     'Current Balance : ${context.read<LedgerReportController>().feedBackModel!.outputBalance![1].currentBalance.toString()}'),
                                  // Text(
                                  //     'Total Amount : ${context.read<LedgerReportController>().feedBackModel!.outputBalance![1].amount.toString()}'),
                                  // Text(
                                  //     'Issuance Date : $formattedEntryDate'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // CustomButton(
                          //   enabledColor: Theme.of(context).primaryColor,
                          //   onTap: () {},
                          //   isloading: false,
                          //   text: 'Print',
                          // ),
                          // const SizedBox(height: 5),
                          // BorderButton(
                          //   onTap: () async {
                          //     setState(() {
                          //       borderIsloading = true;
                          //     });
                          //     try {
                          //       final image = await controller.capture();
                          //       if (image != null) {
                          //         log('Image captured successfully');

                          //         // Get the directory to store the image
                          //         final directory =
                          //             await getTemporaryDirectory();
                          //         final imagePath =
                          //             '${directory.path}/screenshot.png';

                          //         // Save the image to the file system
                          //         final file = File(imagePath);
                          //         await file.writeAsBytes(image);

                          //         // Share the image
                          //         Share.shareXFiles(
                          //           [XFile(imagePath, mimeType: 'image/png')],
                          //         );
                          //         setState(() {
                          //           borderIsloading = false;
                          //         });
                          //       } else {
                          //         log('Failed to capture image');
                          //         setState(() {
                          //           borderIsloading = false;
                          //         });
                          //       }
                          //     } catch (e) {
                          //       log('Error during capture: $e');
                          //       setState(() {
                          //         borderIsloading = false;
                          //       });
                          //     }
                          //   },
                          //   isloading: borderIsloading,
                          //   text: 'Share',
                          // ),
                          const ListTile()
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
