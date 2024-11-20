import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:swiftycompanion/data/models/project_attempts_model.dart';

import 'package:swiftycompanion/data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final String clientId = dotenv.env['APP_UID'].toString();
  final String clientSecret = dotenv.env['APP_SECRET'].toString();

  late final OAuth2Helper _oauth2Helper;

  final client = OAuth2Client(
    authorizeUrl: 'https://api.intra.42.fr/oauth/authorize',
    tokenUrl: 'https://api.intra.42.fr/oauth/token',
    redirectUri: 'swiftycompanion://callback',
    customUriScheme: 'swiftycompanion',
  );

  AuthProvider() {
    _oauth2Helper = OAuth2Helper(client,
        grantType: OAuth2Helper.authorizationCode,
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: ['public']);
  }

  OAuth2Helper get oauth2Helper => _oauth2Helper;

  Future<AccessTokenResponse?> get getToken async =>
      await _oauth2Helper.getToken();

  Future<void> logout(BuildContext context) async {
    await oauth2Helper.disconnect();
    notifyListeners();
  }

  Future<UserModel> getUserData(String userLogin) async {
    late final Response apiResponse;
    if (userLogin == 'me') {
      apiResponse = await oauth2Helper.get('https://api.intra.42.fr/v2/me');
    } else {
      apiResponse =
          await oauth2Helper.get('https://api.intra.42.fr/v2/users/$userLogin');
    }
    if (apiResponse.statusCode != 200) {
      throw Exception('User not found');
    }
    return UserModel.fromJson(jsonDecode(apiResponse.body));
  }

  Future<ProjectAttemptsModel> getProjectAttempts(
      String userLogin, int projectId) async {
    final apiResponse = await oauth2Helper.get(
        'https://api.intra.42.fr/v2/users/$userLogin/projects_users?filter[project_id]=$projectId');
    if (apiResponse.statusCode != 200) {
      throw Exception('Request failed');
    }
    return ProjectAttemptsModel.fromJson(jsonDecode(apiResponse.body));
  }
}
