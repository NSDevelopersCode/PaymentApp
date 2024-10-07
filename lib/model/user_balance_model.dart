import 'dart:convert';
import 'dart:developer';

class UserBalanceModel {
  ResponseObject? responseObject;
  OutputBalance? outputBalance;

  UserBalanceModel({
    this.outputBalance,
    this.responseObject,
  });
  UserBalanceModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> outputData = jsonDecode(json['Output']);
    log(outputData.toString());

    Map<String, dynamic> ticketData =
        outputData.isNotEmpty ? outputData[0] : {};
    log(ticketData.toString());

    responseObject = json['ResponseObject'] != null
        ? ResponseObject.fromJson(json['ResponseObject'])
        : null;
    outputBalance =
        outputData.isNotEmpty ? OutputBalance.fromJson(ticketData) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (responseObject != null) {
      data['ResponseObject'] = responseObject!.toJson();
    }
    if (outputBalance != null) {
      data['Output'] = outputBalance!.toJson();
    }
    return data;
  }
}

class ResponseObject {
  bool? status;
  String? statusDetails;

  ResponseObject({this.status, this.statusDetails});

  factory ResponseObject.fromJson(Map<String, dynamic> json) {
    return ResponseObject(
      status: json['Status'],
      statusDetails: json['StatusDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'StatusDetails': statusDetails,
    };
  }
}

class OutputBalance {
  int? accountId;
  String? accountTitle;
  double? balance;

  OutputBalance({this.accountId, this.accountTitle, this.balance});

  factory OutputBalance.fromJson(Map<String, dynamic> json) {
    return OutputBalance(
        accountId: json['AccountID'],
        accountTitle: json['AccountTitle'],
        balance: json['Balance']);
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountID': accountId,
      'AccountTitle': accountTitle,
      'Balance': balance,
    };
  }
}
