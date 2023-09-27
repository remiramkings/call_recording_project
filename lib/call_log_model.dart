// To parse this JSON data, do
//
//     final callLogModel = callLogModelFromJson(jsonString);

import 'dart:convert';

List<CallLogModel> callLogModelFromJson(String str) => List<CallLogModel>.from(json.decode(str).map((x) => CallLogModel.fromJson(x)));

String callLogModelToJson(List<CallLogModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CallLogModel {
  String? callLogId;
  DateTime? callDateTime;
  DateTime? callRecievedDateTime;
  String? companyId;
  String? userId;
  String? callNumber;
  String? callTypeId;
  String? callStatusId;
  String? callLogKey;
  dynamic realTimeStatus;
  String? clientContactId;
  String? clientId;
  String? callDuration;
  String? statusId;
  String? callStatus;
  String? recordingUrl;
  dynamic clientName;
  String? fullName;
  String? regionId;
  String? branchId;

  CallLogModel({
    this.callLogId,
    this.callDateTime,
    this.callRecievedDateTime,
    this.companyId,
    this.userId,
    this.callNumber,
    this.callTypeId,
    this.callStatusId,
    this.callLogKey,
    this.realTimeStatus,
    this.clientContactId,
    this.clientId,
    this.callDuration,
    this.statusId,
    this.callStatus,
    this.recordingUrl,
    this.clientName,
    this.fullName,
    this.regionId,
    this.branchId,
  });

  factory CallLogModel.fromJson(Map<String, dynamic> json) => CallLogModel(
    callLogId: json["call_log_id"],
    callDateTime: json["call_date_time"] == null ? null : DateTime.parse(json["call_date_time"]),
    callRecievedDateTime: json["call_recieved_date_time"] == null ? null : DateTime.parse(json["call_recieved_date_time"]),
    companyId: json["company_id"],
    userId: json["user_id"],
    callNumber: json["call_number"],
    callTypeId: json["call_type_id"],
    callStatusId: json["call_status_id"],
    callLogKey: json["call_log_key"],
    realTimeStatus: json["real_time_status"],
    clientContactId: json["client_contact_id"],
    clientId: json["client_id"],
    callDuration: json["call_duration"],
    statusId: json["status_id"],
    callStatus: json["call_status"],
    recordingUrl: json["recording_url"]??"",
    clientName: json["client_name"],
    fullName: json["full_name"],
    regionId: json["region_id"],
    branchId: json["branch_id"],
  );

  Map<String, dynamic> toJson() => {
    "call_log_id": callLogId,
    "call_date_time": callDateTime?.toIso8601String(),
    "call_recieved_date_time": callRecievedDateTime?.toIso8601String(),
    "company_id": companyId,
    "user_id": userId,
    "call_number": callNumber,
    "call_type_id": callTypeId,
    "call_status_id": callStatusId,
    "call_log_key": callLogKey,
    "real_time_status": realTimeStatus,
    "client_contact_id": clientContactId,
    "client_id": clientId,
    "call_duration": callDuration,
    "status_id": statusId,
    "call_status": callStatus,
    "recording_url": recordingUrl,
    "client_name": clientName,
    "full_name": fullName,
    "region_id": regionId,
    "branch_id": branchId,
  };

  factory CallLogModel.createDefault(String name, String number){
    return CallLogModel(
      fullName: name,
      callNumber: number
    );
  }
}
