// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:awesome_app/app/data/models/myUser.dart';
import 'package:awesome_app/app/data/models/response.dart';
import 'package:awesome_app/app/data/models/token.dart';
import 'package:awesome_app/app/data/riverpod/token_notifier.dart';
import 'package:awesome_app/base_configs/configs/api_config.dart';
import 'package:awesome_app/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  BuildContext context;
  String token = "";

  ApiClient(this.context);

  ApiClient.withToken(this.context, TokenNotifier tokenNotifier) {
    token = tokenNotifier.getAuthToken() ?? "";
  }

  Future<Response<Token>> userLoginApi(String email, String password) async {
    final response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/${ApiConfig.login}?email=$email&password=$password'));

    if (response.statusCode == 200) {
      Response<Token> successResponse =
          Response.fromJsonWithT(jsonDecode(response.body), Token.fromJson);

      return successResponse;
    } else {
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }
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
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response<MyUser>> addMyUserApi(String name, String email) async {
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
      Response<MyUser> successResponse =
          Response.fromJsonWithT(jsonDecode(response.body), MyUser.fromJson);

      return successResponse;
    } else {
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> getMyUsersApi() async {
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
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response> deleteMyUserApi(String id) async {
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
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }
      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }

  Future<Response<MyUser>> updateMyUserApi(
      String id, String name, String email) async {
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
      Response<MyUser> successResponse =
          Response.fromJsonWithT(jsonDecode(response.body), MyUser.fromJson);

      return successResponse;
    } else {
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }

      Response errorResponse =
          Response.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      throw Exception(errorResponse.message);
    }
  }
}
