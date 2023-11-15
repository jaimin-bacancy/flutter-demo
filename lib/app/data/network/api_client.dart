import 'dart:async';
import 'dart:convert';

import 'package:awesome_app/app/data/models/response.dart';
import 'package:awesome_app/base_configs/configs/api_config.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Response> userLoginApi(String email, String password) async {
    final response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/${ApiConfig.login}?email=$email&password=$password'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did't return a 200 OK response,
      // then parse the JSON.
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> userRegisterApi(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/${ApiConfig.register}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did't return a 200 OK response,
      // then parse the JSON.
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }
}
