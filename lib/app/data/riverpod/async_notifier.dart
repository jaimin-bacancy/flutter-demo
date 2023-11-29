import 'dart:convert';

import 'package:awesome_app/app/data/models/response.dart';
import 'package:awesome_app/app/data/riverpod/token_notifier.dart';
import 'package:awesome_app/base_configs/configs/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_notifier.g.dart';

@riverpod
class AsyncNotifier extends _$AsyncNotifier {
  @override
  Future<Response<dynamic>?> build() async {
    // Load initial todo list from the remote repository
    return null;
  }

  Future<void> addMyUserApi(
      TokenNotifier ref, String name, String email) async {
    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new todo and reload the todo list from the remote repository
    state = await AsyncValue.guard(() async {
      String token = ref.getAuthToken() ?? "";

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
        Response errorResponse = Response.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);

        throw Exception(errorResponse.message);
      }
    });
  }
}
