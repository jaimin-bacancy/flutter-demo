List<Media> usersFromJson(dynamic str) =>
    List<Media>.from(str.map((x) => Media.fromJson(x)));

class Media {
  final String id;
  final String filename;
  final String path;

  const Media({
    required this.filename,
    required this.id,
    required this.path,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      filename: json['filename'] as String,
      id: json['_id'] as String,
      path: json['path'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        filename: filename,
        id: id,
        path: path,
      };
}
