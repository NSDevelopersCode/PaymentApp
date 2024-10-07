import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payment_app/model/user_balance_model.dart';

class UserBalanceController extends ChangeNotifier {
  UserBalanceModel? feedBackModel;
  bool isloading = false;
  final token = '38BB1880-30DB-435F-A413-3D2DCA62EEB5';
  Future<UserBalanceModel> getUserBalanceData({
    // required int ticketNo,
    // required String amount,
    required String username,
    required String password,
    required String terminal,
  }) async {
    isloading = true;
    notifyListeners();
    final Map<String, dynamic> body = {
      "UserCode": username,
      "UserPassword": password,
      "TerminalSerialNo": terminal,
      // "SoftwareVersion": 1.0,
      "ActionType": "8",
      // "ChallanPayment": {"TicketNo": ticketNo, "Amount": amount}
    };
    final bodyString = jsonEncode(body);
    final response = await http.post(
        Uri.parse('https://demokpservice.a2z.care/pay/ProcessPayment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Set the content type to JSON
        },
        body: bodyString);

    final data = jsonDecode(response.body.toString());
    // log(bodyString);
    log(data.toString());
    // List<dynamic> outputData = jsonDecode(data['Output']);

    // Map<String, dynamic> ticketData =
    //     outputData.isNotEmpty ? outputData[0] : {};

// Extract the DutyPoint_ID

    if (response.statusCode == 200) {
      print('1');
      isloading = false;
      notifyListeners();
      // TicketOutputModel ticketOutput = TicketOutputModel.fromJson(ticketData);
      // log(ticketData.toString());
      feedBackModel = UserBalanceModel.fromJson(data);
      if (feedBackModel != null) {
        // Log feedBackModel
        log(feedBackModel!.toJson().toString());
        // Log output and its districtId if available
        if (feedBackModel!.outputBalance != null) {
          log(feedBackModel!.outputBalance!.toJson().toString());
          log(feedBackModel!.outputBalance!.balance.toString());
        }
      } else {
        print('object');
      }
      return feedBackModel!;
    } else {
      isloading = false;
      notifyListeners();
      return UserBalanceModel.fromJson(data);
    }
  }
}
