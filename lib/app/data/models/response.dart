class Response<T> {
  final bool isSuccess;
  final String message;
  final int code;
  final T? data;

  const Response({
    required this.isSuccess,
    required this.message,
    required this.code,
    required this.data,
  });

  factory Response.fromJsonWithT(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return Response<T>(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: json['data'] == null ? null : fromJsonT(json['data']),
    );
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response<T>(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: json['data'] as T,
    );
  }
}
