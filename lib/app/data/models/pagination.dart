class Pagination {
  int total;
  int offset;

  Pagination({
    required this.total,
    required this.offset,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "offset": offset,
      };
}
