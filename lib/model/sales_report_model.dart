import 'dart:convert';
import 'dart:developer';

class SalesReportModel {
  ResponseObject? responseObject;
  List<OutputBalance>? outputBalance;

  SalesReportModel({
    this.outputBalance,
    this.responseObject,
  });
  SalesReportModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> outputData = jsonDecode(json['Output']);
    log(outputData.toString());

    outputBalance = [];

    if (outputData.isNotEmpty) {
      for (var item in outputData) {
        Map<String, dynamic> ticketData = item;
        outputBalance!.add(
          OutputBalance.fromJson(ticketData),
        );
      }
    } else {
      outputBalance = null;
    }
    // Map<String, dynamic> ticketData =
    //     outputData.isNotEmpty ? outputData[0] : {};
    // log(ticketData.toString());

    responseObject = json['ResponseObject'] != null
        ? ResponseObject.fromJson(json['ResponseObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (responseObject != null) {
      data['ResponseObject'] = responseObject!.toJson();
    }
    if (outputBalance != null) {
      data['Output'] = outputBalance!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ResponseObject {
  bool? status;
  String? statusDetails;
  String? merchantName;

  ResponseObject({this.status, this.statusDetails, this.merchantName});

  factory ResponseObject.fromJson(Map<String, dynamic> json) {
    return ResponseObject(
      status: json['Status'],
      statusDetails: json['StatusDetails'],
      merchantName: json['MerchantName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'StatusDetails': statusDetails,
      'MerchantName': merchantName,
    };
  }
}

class OutputBalance {
  String? transactionDate;
  String? productName;
  double? amount;
  double? currentBalance;
  String? merchantName;
  int? quantity;

  OutputBalance(
      {this.amount,
      this.currentBalance,
      this.merchantName,
      this.productName,
      this.quantity,
      this.transactionDate});

  factory OutputBalance.fromJson(Map<String, dynamic> json) {
    return OutputBalance(
        amount: json['Amount'],
        currentBalance: json['CurrentBalance'],
        merchantName: json['MerchantName'],
        productName: json['ProductName'],
        quantity: json['Quantity'],
        transactionDate: json['TransactionDate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Amount': amount,
      'CurrentBalance': currentBalance,
      'MerchantName': merchantName,
      'ProductName': productName,
      'Quantity': quantity,
      'TransactionDate': transactionDate,
    };
  }
}
