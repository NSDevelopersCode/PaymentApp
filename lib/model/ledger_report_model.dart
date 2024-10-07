import 'dart:convert';
import 'dart:developer';

class LedgerReportModel {
  ResponseObject? responseObject;
  List<OutputBalance>? outputBalance;

  LedgerReportModel({
    this.outputBalance,
    this.responseObject,
  });
  LedgerReportModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> outputData = jsonDecode(json['Output']);
    log(outputData.toString());

    outputBalance = [];
    if (outputData.isNotEmpty) {
      for (var item in outputData) {
        outputBalance!.add(OutputBalance.fromJson(item));
      }
    } else {
      outputBalance = null;
    }
    Map<String, dynamic> ticketData =
        outputData.isNotEmpty ? outputData[0] : {};
    log(ticketData.toString());

    responseObject = json['ResponseObject'] != null
        ? ResponseObject.fromJson(json['ResponseObject'])
        : null;

    outputBalance = outputBalance;
    // outputBalance =
    //     outputData.isNotEmpty ? OutputBalance.fromJson(ticketData) : null;
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
  String? entryDate;
  String? particulars;
  double? amount;
  double? currentBalance;

  int? totalTx;

  OutputBalance(
      {this.amount,
      this.currentBalance,
      this.particulars,
      this.totalTx,
      this.entryDate});

  factory OutputBalance.fromJson(Map<String, dynamic> json) {
    return OutputBalance(
        amount: json['Amount'],
        currentBalance: json['Balance'],
        particulars: json['Particulars'],
        totalTx: json['TotalTx'],
        entryDate: json['EntryDate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Amount': amount,
      'Balance': currentBalance,
      'Particulars': particulars,
      'TotalTx': totalTx,
      'EntryDate': entryDate,
    };
  }
}
