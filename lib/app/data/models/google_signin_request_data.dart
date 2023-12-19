class GoogleSignInRequestData {
  final String idToken;

  const GoogleSignInRequestData({
    required this.idToken,
  });

  factory GoogleSignInRequestData.fromJson(Map<String, dynamic> json) {
    return GoogleSignInRequestData(
      idToken: json['idToken'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "idToken": idToken,
      };
}
