// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_app/app/data/models/media.dart';
import 'package:awesome_app/app/data/models/myUser.dart';
import 'package:awesome_app/app/data/models/paginated_response.dart';
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

  Future<Response<Token>> userSocialLoginApi<T>(
    String socialType,
    Map<String, dynamic> extraData,
  ) async {
    final response = await http.post(
      Uri.parse(
          '${ApiConfig.baseUrl}/${ApiConfig.socialLogin}?socialType=$socialType'),
      body: extraData,
    );

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

  Future<Response<MyUser>> addMyUserApi(
      String name, String email, Media? media, DateTime dob) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/${ApiConfig.addUser}'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
        ApiConfig.authorization: "${ApiConfig.bearer} $token",
      },
      body: jsonEncode(<String, dynamic>{
        ApiConfig.name: name,
        ApiConfig.email: email,
        ApiConfig.profile: media,
        ApiConfig.dob: dob.toString(),
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

  Future<PaginatedResponse<MyUser>> getMyUsersApi(
      String searchText, int offset) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/${ApiConfig.myUsers}?query=$searchText&offset=$offset&limit=10'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
        ApiConfig.authorization: "${ApiConfig.bearer} $token",
      },
    );

    if (response.statusCode == 200) {
      PaginatedResponse<MyUser> successResponse = PaginatedResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>, MyUser.fromJson);

      return successResponse;
    } else {
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }
      PaginatedResponse errorResponse = PaginatedResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>, MyUser.fromJson);

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
      String id, String name, String email, Media? media, DateTime dob) async {
    final response = await http.put(
      Uri.parse(
          '${ApiConfig.baseUrl}/${ApiConfig.user}/$id/${ApiConfig.updateUser}'),
      headers: <String, String>{
        ApiConfig.contentType: 'application/json; charset=UTF-8',
        ApiConfig.authorization: "${ApiConfig.bearer} $token",
      },
      body: jsonEncode(<String, dynamic>{
        ApiConfig.name: name,
        ApiConfig.email: email,
        ApiConfig.profile: media,
        ApiConfig.dob: dob.toString(),
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

  Future<Response<Media>> upload(File file) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('${ApiConfig.baseUrl}/${ApiConfig.upload}'));

    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("image", file.path);
    //add multipart to request
    request.files.add(pic);

    http.StreamedResponse response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    if (response.statusCode == 200) {
      Response<Media> successResponse =
          Response.fromJsonWithT(jsonDecode(responseString), Media.fromJson);

      return successResponse;
    } else {
      if (response.statusCode == 401) {
        CommonMethods.resetToStartUp(context);
      }

      Response errorResponse =
          Response.fromJsonWithT(jsonDecode(responseString), Media.fromJson);

      throw Exception(errorResponse.message);
    }
  }
}
