import 'dart:convert';

class DepositPrintModel {
  ResponseObject? responseObject;
  DepositOutputModel? output;

  DepositPrintModel({this.responseObject, this.output});

  DepositPrintModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> outputData = jsonDecode(json['Output']);

    Map<String, dynamic> ticketData =
        outputData.isNotEmpty ? outputData[0] : {};

    responseObject = json['ResponseObject'] != null
        ? ResponseObject.fromJson(json['ResponseObject'])
        : null;
    output =
        outputData.isNotEmpty ? DepositOutputModel.fromJson(ticketData) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (responseObject != null) {
      data['ResponseObject'] = responseObject!.toJson();
    }
    if (output != null) {
      data['Output'] = output!.toJson();
    }
    return data;
  }
}

class ResponseObject {
  bool? status;
  String? statusDetails;

  ResponseObject({this.status, this.statusDetails});

  ResponseObject.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusDetails = json['StatusDetails'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'StatusDetails': statusDetails,
    };
  }
}

class DepositOutputModel {
  int? depositId;
  double? totalAmount;
  double? merchantBalance;
  int? noOfTickets;
  String? paidDataTime;
  String? generateDataTime;
  String? merchantName;
  String? productName;
  String? toName;

  // Add other fields as needed

  DepositOutputModel({
    required this.depositId,
    required this.generateDataTime,
    required this.noOfTickets,
    required this.paidDataTime,
    required this.productName,
    required this.totalAmount,
    required this.merchantName,
    required this.toName,
    this.merchantBalance,
    // Add other fields as needed
  });

  factory DepositOutputModel.fromJson(Map<String, dynamic> json) {
    return DepositOutputModel(
        depositId: json['DepositID'],
        noOfTickets: json['NoOfTickets'],
        generateDataTime: json['GeneratedDateTime'],
        paidDataTime: json['PaidDateTime'],
        productName: json['ProductName'],
        totalAmount: json['TotalAmount'],
        merchantName: json['MerchantName'],
        toName: json['TOName'],
        merchantBalance: json['MerchantBalance']
        // ticketId: json['TicketID'],
        // districtId: json['District_ID'],
        // toId: json['TO_ID'],
        // dutyPointId: json['DutyPoint_ID'],
        // boxId: json['Box_ID'],
        // documentcellId: json['DocumentCell_ID'],
        // ticketactionId: json['TicketAction_ID'],
        // ticketStatusId: json['TicketStatus_ID'],
        // toticketNo: json['TOTicketNo'],
        // ticketNo: json['TicketNo'],
        // issuanceDataTime: json['IssuanceDateTime'],
        // offenderName: json['OffenderName'],
        // cnic: json['CNIC'],
        // mobileNumber: json['MobileNumber'],
        // vehicleNumber: json['VehicleNumber'],
        // deviceId: json['Device_ID'],
        // applicationName: json['ApplicationName'],
        // loginId: json['Log_ID'],
        // ticketAmount: json['TicketAmount'],
        // serviceCharges: json['ServiceCharges'],
        // activityDateTime: json['ActivityDateTime'],
        // transactionTime: json['TransactionDateTime'],
        // toName: json['TOName'],
        // merchantName: json['MerchantName'],
        // violationCodes: json['ViolationsCodes'],
        // Add other fields as needed
        );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalAmount'] = totalAmount;
    data['PaidDateTime'] = paidDataTime;
    data['GeneratedDateTime'] = generateDataTime;
    data['DepositID'] = depositId;
    data['MerchantName'] = merchantName;
    data['MerchantBalance'] = merchantBalance;
    data['ProductName'] = productName;
    data['TOName'] = toName;
    data['NoOfTickets'] = noOfTickets;

    // Add other fields as needed
    return data;
  }
}
