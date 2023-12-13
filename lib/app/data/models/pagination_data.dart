import 'package:awesome_app/app/data/models/pagination.dart';

List<T> paginationDataFromJson<T>(
    List<T> data, T Function(Map<String, dynamic>) fromJsonT) {
  return List<T>.from(data.map((x) => x));
}

class PaginationData<T> {
  List<T> items;
  Pagination pagination;

  PaginationData({
    required this.items,
    required this.pagination,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json,
          T Function(Map<String, dynamic>) fromJsonT) =>
      PaginationData<T>(
        items: List<T>.from(json["items"].map((x) => fromJsonT(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "items": List<T>.from(items.map((x) => x)),
        "pagination": pagination.toJson(),
      };
}
