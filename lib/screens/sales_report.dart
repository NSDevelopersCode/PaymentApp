import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:payment_app/common/borderbutton.dart';
import 'package:payment_app/common/custombutton.dart';
import 'package:payment_app/controller/sales_report_controller.dart';
import 'package:payment_app/model/sales_report_model.dart';
import 'package:payment_app/utils/dropdown.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class SalesRport extends StatefulWidget {
  const SalesRport(
      {super.key,
      required this.password,
      required this.terminal,
      required this.username,
      required this.ids,
      required this.names});
  final String username;
  final String password;
  final String terminal;
  final List<String> ids;
  final List<String> names;

  @override
  State<SalesRport> createState() => _SalesRportState();
}

class _SalesRportState extends State<SalesRport> {
  bool isloading = false;
  List<OutputBalance>? outputBalances;
  final ScreenshotController controller = ScreenshotController();

  DateTime? _fromSelectedDate = DateTime.now();
  DateTime? _toSelectedDate = DateTime.now();
  // int? count;
  final List<String> _options = ["Pick Date from Calendar"]; // Dropdown options
  String productName = '';
  String productId = '';

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(), // Current date as default
  //     firstDate: DateTime(2000), // Earliest date that can be selected
  //     lastDate: DateTime(2101), // Latest date that can be selected
  //   );
  //   if (pickedDate != null) {
  //     setState(() {
  //       // Format the picked date and update the selected value
  //       _selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
  //     });
  //   }
  // }

  // Populate a list of dates (e.g., the next 7 days from today)
  // void _populateDates() {
  //   final DateTime now = DateTime.now();
  //   _datesList = List.generate(7, (index) => now.add(Duration(days: index)));
  // }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    int quantity = 0;
    double amount = 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Sales Report'),
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
                  title: "From Date",
                  initialDate: DateTime.now(),
                  onChanged: (date) {
                    setState(() {
                      _fromSelectedDate = date;
                    });
                    log(_fromSelectedDate.toString());
                  },
                  hint: 'Select From Date',
                ),
                const SizedBox(height: 10),
                CustomDatePickerField(
                  hint: 'Select To Date',
                  selectedDate: _toSelectedDate,
                  title: "To Date",
                  initialDate: DateTime.now(),
                  onChanged: (date) {
                    setState(() {
                      _toSelectedDate = date;
                    });
                    log(_toSelectedDate!.myDate.toString());
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 100),
                  child: CustomDropdownFieldAgain(
                    title: 'Select Product ID',
                    value: productName,
                    items: widget.names,
                    onChanged: (value) {
                      log('value is $value');
                      // viewModel.getCities(value);
                      setState(() {
                        productName = value!;
                        int index = widget.names.indexOf(value);
                        productId = widget.ids[index];
                        log(productId);
                        // viewModel.driverName.value = value!;
                        // _selectedDropdownValues[index] = value;
                        // log('list is $_selectedDropdownValues');
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  enabledColor: Theme.of(context)
                      .primaryColor, // Button color when enabled
                  disabledColor: Colors.grey,
                  onTap: _fromSelectedDate != null &&
                          _toSelectedDate != null &&
                          productName.isNotEmpty
                      ? () async {
                          try {
                            setState(() {
                              isloading = true;
                            });
                            // Fetching Sales Report Data
                            await context
                                .read<SalesReportController>()
                                .getSalesReportData(
                                    username: widget.username,
                                    password: widget.password,
                                    terminal: widget.terminal,
                                    fromDate: _fromSelectedDate.toString(),
                                    toDate: _toSelectedDate.toString(),
                                    productID: int.parse(productId));

                            setState(() {
                              isloading = false;
                            });

                            // Checking the response
                            if (context
                                        .read<SalesReportController>()
                                        .feedBackModel!
                                        .responseObject!
                                        .status ==
                                    true &&
                                context
                                        .read<SalesReportController>()
                                        .feedBackModel!
                                        .outputBalance !=
                                    null) {
                              outputBalances = context
                                  .read<SalesReportController>()
                                  .feedBackModel!
                                  .outputBalance!;

                              // Loop through each balance and handle transaction dates
                              // for (var balance in outputBalances) {
                              //   if (balance.transactionDate != null) {
                              // final transactionDate =
                              //     DateTime.parse(balance.transactionDate!);
                              // log(transactionDate.toString());

                              // final formattedTransactionDate =
                              //     DateFormat('dd-MMM-yy hh:mm a')
                              //         .format(transactionDate);

                              // Show dialog for each output balance
                              // showDialog(
                              //   barrierDismissible: false,
                              //   context: context,
                              //   builder: (context) {
                              //     return Center(
                              //       child: Stack(
                              //         children: [
                              //           Column(
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: [
                              //               // MyDialogue(
                              //               //     controller: controller,
                              //               //     outputBalances: outputBalances,
                              //               //     fromSelectedDate:
                              //               //         _fromSelectedDate,
                              //               //     toSelectedDate: _toSelectedDate),

                              //             ],
                              //           ),
                              //           Positioned(
                              //             top: 15,
                              //             right: 25,
                              //             child: GestureDetector(
                              //               onTap: () {
                              //                 Navigator.pop(context);
                              //               },
                              //               child: Image.asset(
                              //                 'assets/images/cancel.png',
                              //                 height: 35,
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              // );
                            }
                            //}
                            //}
                            else {
                              context.showSnackBar('Output is empty',
                                  backgroundColor: Colors.red);
                            }
                          } on SocketException catch (e) {
                            log(e.message.toString());
                            context.showSnackBar(e.message,
                                backgroundColor: Colors.red);
                            setState(() {
                              isloading = false;
                            });
                          }
                        }
                      : null,
                  isloading: isloading,
                  text: 'Get Sales Report',
                ),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Merchant  : ${outputBalances![0].merchantName!}',
                                    maxLines: 1,
                                  ),
                                  Text(
                                      'From Date  : ${_fromSelectedDate!.myDate}'),
                                  Text('To Date : ${_toSelectedDate!.myDate}'),
                                  Text(
                                      'Product : ${outputBalances![0].productName!}'),
                                  const SizedBox(
                                    height: 10,
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
                                        'Qty',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: outputBalances!.map((e) {
                                      final transactionDate =
                                          DateTime.parse(e.transactionDate!);
                                      count = count + 1;
                                      quantity = quantity + e.quantity!;
                                      amount = amount + e.amount!;
                                      final formattedTransactionDate =
                                          DateFormat('MMM-dd')
                                              .format(transactionDate);
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(formattedTransactionDate),
                                          Text(e.quantity!.toString()),
                                          Text(e.amount!.toString())
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  const Text(
                                    '-------------------------------------------------------------------------------------------',
                                    maxLines: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('$count ' 'days'),
                                      Text(quantity.toString()),
                                      Text(amount.toString()),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      'Current Balance : ${outputBalances![0].currentBalance ?? ''}'),
                                  Text(
                                      'Printed on : ${DateFormat('dd-MMM-yy hh:mm a').format(DateTime.now())}'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
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
                          //       } else {
                          //         log('Failed to capture image');
                          //       }
                          //     } catch (e) {
                          //       log('Error during capture: $e');
                          //     }
                          //   },
                          //   isloading: false,
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

class MyDialogueContent extends StatelessWidget {
  const MyDialogueContent({
    super.key,
    required this.outputBalances,
    required DateTime? fromSelectedDate,
    required DateTime? toSelectedDate,
  })  : _fromSelectedDate = fromSelectedDate,
        _toSelectedDate = toSelectedDate;

  final List<OutputBalance> outputBalances;
  final DateTime? _fromSelectedDate;
  final DateTime? _toSelectedDate;

  @override
  Widget build(BuildContext context) {
    int count = 0;
    int quantity = 0;
    double amount = 0.0;
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/images/checked.png',
            height: 80,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Sales Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Merchant  : ${outputBalances[0].merchantName!}',
              maxLines: 1,
            ),
            Text('From Date  : ${_fromSelectedDate!.myDate}'),
            Text('To Date : ${_toSelectedDate!.myDate}'),
            Text('Product : ${outputBalances[0].productName!}'),
            const Text(
              '------------------------------------------------------------',
              maxLines: 1,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date'),
                Text('Qty'),
                Text('Amount'),
              ],
            ),
            const Text(
              '------------------------------------------------------------',
              maxLines: 1,
            ),
            Column(
              children: outputBalances.map((e) {
                final transactionDate = DateTime.parse(e.transactionDate!);
                count = count + 1;
                quantity = quantity + e.quantity!;
                amount = amount + e.amount!;
                final formattedTransactionDate =
                    DateFormat('MMM-dd').format(transactionDate);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedTransactionDate),
                    Text(e.quantity!.toString()),
                    Text(e.amount!.toString())
                  ],
                );
              }).toList(),
            ),
            const Text(
              '------------------------------------------------------------',
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$count ' 'days'),
                Text(quantity.toString()),
                Text(amount.toString()),
              ],
            ),
            const Text(
              '------------------------------------------------------------',
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            Text('Current Balance : ${outputBalances[0].currentBalance ?? ''}'),
            Text(
                'Printed on : ${DateFormat('dd-MMM-yy hh:mm a').format(DateTime.now())}'),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MyDialogue extends StatelessWidget {
  const MyDialogue({
    super.key,
    required this.controller,
    required this.outputBalances,
    required DateTime? fromSelectedDate,
    required DateTime? toSelectedDate,
  })  : _fromSelectedDate = fromSelectedDate,
        _toSelectedDate = toSelectedDate;

  final ScreenshotController controller;
  final List<OutputBalance> outputBalances;
  final DateTime? _fromSelectedDate;
  final DateTime? _toSelectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        CustomButton(
          enabledColor: Theme.of(context).primaryColor,
          onTap: () {},
          isloading: false,
          text: 'Print',
        ),
        const SizedBox(height: 5),
        BorderButton(
          onTap: () async {
            try {
              final image = await controller.capture();
              log(image.toString());
              if (image != null) {
                log('Image captured successfully');
                Share.shareXFiles(
                  [
                    XFile.fromData(
                      image,
                      mimeType: 'image/png',
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
          text: 'Share',
        ),
      ],
      content: Screenshot(
        controller: controller,
        child: MyDialogueContent(
          outputBalances: outputBalances,
          fromSelectedDate: _fromSelectedDate,
          toSelectedDate: _toSelectedDate,
        ),
      ),
    );
  }
}

extension BottomBar on BuildContext {
  void showSnackBar(String message,
      {Color backgroundColor = Colors.black,
      Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}

class CustomDatePickerField extends StatelessWidget {
  final String? title;
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? selectedDate;
  final String hint;

  const CustomDatePickerField({
    Key? key,
    this.title,
    this.initialDate,
    required this.onChanged,
    required this.selectedDate,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      sufixIcon: IconButton(
        icon: const Icon(Icons.calendar_month),
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            helpText: 'Select Date',
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1960),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            onChanged(picked);
          }
        },
      ),
      controller: TextEditingController(
        text: selectedDate?.myDate ?? hint,
      ),
      readOnly: true,
    );
  }
}

extension CustomDate on DateTime {
  String get myDate {
    return '$day/$month/$year';
  }
}

class CustomTextField extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final AutovalidateMode? autoValidateMode;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final Color textColor;
  final bool? showCursor;
  final bool readOnly;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final List<TextInputFormatter> inputFormatter;
  static const Color fillColorDefaultValue = Color(0xffF0F0F0);
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    this.onTap,
    this.validator,
    this.obscureText = false,
    this.autoValidateMode,
    this.title,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.showCursor,
    this.readOnly = false,
    this.hintText,
    this.prefixIcon,
    this.sufixIcon,
    this.textColor = Colors.black54,
    this.onChanged,
    this.focusNode,
    this.inputFormatter = const <TextInputFormatter>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title == null)
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 3, left: 2, right: 2),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff101817),
                  ),
                ),
              ),
        const SizedBox(height: 5),
        TextFormField(
          focusNode: focusNode,
          onChanged: onChanged,
          showCursor: showCursor,
          readOnly: readOnly,
          minLines: minLines,
          maxLines: maxLines,
          onTap: onTap,
          autovalidateMode: autoValidateMode,
          obscureText: obscureText,
          validator: validator,
          inputFormatters: inputFormatter,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: const Color(0xff0c1a4b3d).withOpacity(0.06))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: const Color(0xff0c1a4b3d).withOpacity(0.06))),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.red)),
            prefixIcon: prefixIcon,
            suffixIcon: sufixIcon,
            fillColor: Colors.grey.shade200.withOpacity(0.5),
            filled: true,
            hintText: hintText,
            errorStyle: const TextStyle(color: Colors.red),
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(13, 17, 13, 17),
          ),
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
