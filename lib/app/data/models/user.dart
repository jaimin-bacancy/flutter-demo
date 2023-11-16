List<User> usersFromJson(dynamic str) =>
    List<User>.from(str.map((x) => User.fromJson(x)));

class User {
  final String id;
  final String name;
  final String email;

  const User({
    required this.name,
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      id: json['_id'] as String,
      email: json['email'] as String,
    );
  }
}
