import 'dart:convert';

class TicketPaymentModel {
  ResponseObject? responseObject;
  TicketOutputModel? output;

  TicketPaymentModel({this.responseObject, this.output});

  TicketPaymentModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> outputData = jsonDecode(json['Output']);

    Map<String, dynamic> ticketData =
        outputData.isNotEmpty ? outputData[0] : {};

    responseObject = json['ResponseObject'] != null
        ? ResponseObject.fromJson(json['ResponseObject'])
        : null;
    output =
        outputData.isNotEmpty ? TicketOutputModel.fromJson(ticketData) : null;
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

class TicketOutputModel {
  int? ticketId;
  int? districtId;
  int? toId;
  int? dutyPointId;
  int? boxId;
  int? documentcellId;
  int? ticketactionId;
  int? ticketStatusId;
  int? toticketNo;
  int? ticketNo;
  String? issuanceDataTime;
  String? transactionTime;
  String? activityDateTime;
  String? offenderName;
  String? cnic;
  String? mobileNumber;
  String? vehicleNumber;
  int? deviceId;
  String? applicationName;
  String? toName;
  String? violationCodes;
  int? loginId;
  int? ticketAmount;
  double? serviceCharges;
  double? totalAmount;
  String? merchantName;
  double? merchantBalance;

  // Add other fields as needed

  TicketOutputModel({
    this.ticketId,
    this.districtId,
    this.toId,
    this.dutyPointId,
    this.boxId,
    this.documentcellId,
    this.ticketactionId,
    this.ticketStatusId,
    this.toticketNo,
    this.ticketNo,
    this.issuanceDataTime,
    this.offenderName,
    this.cnic,
    this.mobileNumber,
    this.vehicleNumber,
    this.deviceId,
    this.applicationName,
    this.loginId,
    this.ticketAmount,
    this.serviceCharges,
    this.activityDateTime,
    this.transactionTime,
    this.toName,
    this.violationCodes,
    this.merchantName,
    this.merchantBalance,
    this.totalAmount,

    // Add other fields as needed
  });

  factory TicketOutputModel.fromJson(Map<String, dynamic> json) {
    return TicketOutputModel(
      ticketId: json['TicketID'],
      districtId: json['District_ID'],
      toId: json['TO_ID'],
      dutyPointId: json['DutyPoint_ID'],
      boxId: json['Box_ID'],
      documentcellId: json['DocumentCell_ID'],
      ticketactionId: json['TicketAction_ID'],
      ticketStatusId: json['TicketStatus_ID'],
      toticketNo: json['TOTicketNo'],
      ticketNo: json['TicketNo'],
      issuanceDataTime: json['IssuanceDateTime'],
      offenderName: json['OffenderName'],
      cnic: json['CNIC'],
      mobileNumber: json['MobileNumber'],
      vehicleNumber: json['VehicleNumber'],
      deviceId: json['Device_ID'],
      applicationName: json['ApplicationName'],
      loginId: json['Log_ID'],
      ticketAmount: json['TicketAmount'],
      serviceCharges: json['ServiceCharges'],
      totalAmount: json['TotalAmount'],
      activityDateTime: json['ActivityDateTime'],
      transactionTime: json['TransactionDateTime'],
      toName: json['TOName'],
      merchantName: json['MerchantName'],
      violationCodes: json['ViolationsCodes'],
      merchantBalance: json['MerchantBalance'],
      // Add other fields as needed
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TicketID'] = ticketId;
    data['District_ID'] = districtId;
    data['TO_ID'] = toId;
    data['DutyPoint_ID'] = dutyPointId;
    data['Box_ID'] = boxId;
    data['DocumentCell_ID'] = documentcellId;
    data['TicketAction_ID'] = ticketactionId;
    data['TicketStatus_ID'] = ticketStatusId;
    data['TOTicketNo'] = toticketNo;
    data['TicketNo'] = ticketNo;
    data['IssuanceDateTime'] = issuanceDataTime;
    data['OffenderName'] = offenderName;
    data['CNIC'] = cnic;
    data['MobileNumber'] = mobileNumber;
    data['VehicleNumber'] = vehicleNumber;
    data['Device_ID'] = deviceId;
    data['ApplicationName'] = applicationName;
    data['Log_ID'] = loginId;
    data['TicketAmount'] = ticketAmount;
    data['ServiceCharges'] = serviceCharges;
    data['TotalAmount'] = totalAmount;
    data['ActivityDateTime'] = activityDateTime;
    data['TransactionDateTime'] = transactionTime;
    data['TOName'] = toName;
    data['ViolationsCodes'] = violationCodes;
    data['MerchantName'] = merchantName;
    data['MerchantBalance'] = merchantBalance;

    // Add other fields as needed
    return data;
  }
}
