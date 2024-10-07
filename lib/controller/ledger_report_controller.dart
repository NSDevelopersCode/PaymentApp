import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payment_app/model/ledger_report_model.dart';

class LedgerReportController extends ChangeNotifier {
  LedgerReportModel? feedBackModel;
  bool isloading = false;
  final token = '38BB1880-30DB-435F-A413-3D2DCA62EEB5';
  Future<LedgerReportModel> getLedgerReportData({
    required String username,
    required String password,
    required String terminal,
    required String fromDate,
    required String toDate,
  }) async {
    final Map<String, dynamic> body = {
      "UserCode": username,
      "UserPassword": password,
      "TerminalSerialNo": terminal,
      "FromDate": fromDate,
      "ToDate": toDate,
      "ProductID": 23,
      "ActionType": "10"

      // "UserCode": "0000",
      // "UserPassword": "0000",
      // "TerminalSerialNo": "82332287",
      // "FromDate": "2024-09-12 12:19:43.703",
      // "ToDate": "2024-09-19 12:57:01.830",
      // "ProductID": 23,
      // "ActionType": "10"
    };
    final bodyString = jsonEncode(body);

    final response = await http.post(
        Uri.parse('https://demokpservice.a2z.care/pay/ProcessPayment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Set the content type to JSON
        },
        body: bodyString);
    log(response.body.toString());

    final data = jsonDecode(response.body.toString());
    // log(data);
    if (response.statusCode == 200) {
      log('1');
      feedBackModel = LedgerReportModel.fromJson(data);
      if (feedBackModel != null) {
        // Log feedBackModel
        // log(feedBackModel!.toJson().toString());
        // Log output and its districtId if available
        if (feedBackModel!.outputBalance != null) {
          // log(feedBackModel!.outputBalance!.toJson().toString());
          // log(feedBackModel!.outputBalance!.amount.toString());
        }
      } else {
        print('object');
      }
      return feedBackModel!;
    } else {
      log('message');
      isloading = false;
      notifyListeners();
      return LedgerReportModel.fromJson(data);
    }
  }
}
