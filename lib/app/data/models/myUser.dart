List<MyUser> usersFromJson(dynamic str) =>
    List<MyUser>.from(str.map((x) => MyUser.fromJson(x)));

class MyUser {
  final String id;
  final String name;
  final String email;
  final String? createdBy;

  const MyUser({
    required this.name,
    required this.id,
    required this.email,
    this.createdBy,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      name: json['name'] as String,
      id: json['_id'] as String,
      email: json['email'] as String,
      createdBy: json['createdBy'] as String,
    );
  }
}
