import 'dart:async';
import 'dart:convert';

import 'package:awesome_app/app/data/models/response.dart';
import 'package:awesome_app/app/data/models/token.dart';
import 'package:awesome_app/base_configs/configs/api_config.dart';
import 'package:awesome_app/utils/shared_pref_utils.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Response<Token>> userLoginApi(String email, String password) async {
    final response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/${ApiConfig.login}?email=$email&password=$password'));

    if (response.statusCode == 200) {
      Response<Token> successResponse =
          Response.fromJsonWithT(jsonDecode(response.body), Token.fromJson);

      return successResponse;
    } else {
      Response errorResponse =
          Response.fromJsonWithT(jsonDecode(response.body), Token.fromJson);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> userRegisterApi(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/${ApiConfig.register}'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        ApiConfig.name: name,
        ApiConfig.email: email,
        ApiConfig.password: password,
      }),
    );

    if (response.statusCode == 200) {
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> addMyUserApi(String name, String email) async {
    String token = SharedPrefUtils().getUserToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/${ApiConfig.addUser}'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
        ApiConfig.authorization: "${ApiConfig.bearer} $token",
      },
      body: jsonEncode(<String, String>{
        ApiConfig.name: name,
        ApiConfig.email: email,
      }),
    );

    if (response.statusCode == 200) {
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> getMyUsersApi() async {
    String token = SharedPrefUtils().getUserToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/${ApiConfig.myUsers}'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
        ApiConfig.authorization: "${ApiConfig.bearer} $token",
      },
    );

    if (response.statusCode == 200) {
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> deleteMyUserApi(String id) async {
    String token = SharedPrefUtils().getUserToken();

    final response = await http.delete(
      Uri.parse(
          '${ApiConfig.baseUrl}/${ApiConfig.user}/$id/${ApiConfig.removeUser}'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
        ApiConfig.authorization: "${ApiConfig.bearer} $token",
      },
    );

    if (response.statusCode == 200) {
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> updateMyUserApi(String id, String name, String email) async {
    String token = SharedPrefUtils().getUserToken();

    final response = await http.put(
      Uri.parse(
          '${ApiConfig.baseUrl}/${ApiConfig.user}/$id/${ApiConfig.updateUser}'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
        ApiConfig.authorization: "${ApiConfig.bearer} $token",
      },
      body: jsonEncode(<String, String>{
        ApiConfig.name: name,
        ApiConfig.email: email,
      }),
    );

    if (response.statusCode == 200) {
      return Response.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }
}
