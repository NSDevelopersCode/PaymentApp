import 'dart:convert';
import 'dart:developer';

class LoginModel {
  ResponseObject? responseObject;
  List<Output>? output;

  LoginModel({this.responseObject, this.output});

  LoginModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> outputData = jsonDecode(json['Output']);
    log(outputData.toString());

    output = [];
    if (outputData.isNotEmpty) {
      for (var item in outputData) {
        output!.add(Output.fromJson(item));
      }
    } else {
      output = null;
    }
    Map<String, dynamic> ticketData =
        outputData.isNotEmpty ? outputData[0] : {};
    log(ticketData.toString());

    responseObject = json['ResponseObject'] != null
        ? ResponseObject.fromJson(json['ResponseObject'])
        : null;
    output = output;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (responseObject != null) {
      data['ResponseObject'] = responseObject!.toJson();
    }

    data['Output'] = output;

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

class Output {
  final int productId;
  final String productName;

  Output({
    required this.productId,
    required this.productName,
  });

  factory Output.fromJson(Map<String, dynamic> json) {
    return Output(
      productId: json['ProductID'],
      productName: json['ProductName'],
    );
  }
}
