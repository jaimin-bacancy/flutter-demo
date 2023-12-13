// To parse this JSON data, do
//
//     final paginatedResponse = paginatedResponseFromJson(jsonString);

import 'package:awesome_app/app/data/models/pagination_data.dart';

PaginatedResponse<T> paginatedResponseFromJson<T>(Map<String, dynamic> json,
        T Function(Map<String, dynamic>) fromJsonT) =>
    PaginatedResponse.fromJson(json, fromJsonT);

class PaginatedResponse<T> {
  bool isSuccess;
  String message;
  int code;
  PaginationData<T> data;

  PaginatedResponse({
    required this.isSuccess,
    required this.message,
    required this.code,
    required this.data,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json,
          T Function(Map<String, dynamic>) fromJsonT) =>
      PaginatedResponse(
        isSuccess: json["isSuccess"],
        message: json["message"],
        code: json["code"],
        data: PaginationData<T>.fromJson(json["data"], fromJsonT),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "code": code,
        "data": data.toString(),
      };
}
