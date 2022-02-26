import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:diuspeeder/auth_BLC/blc_url_path.dart';
import 'package:diuspeeder/auth_BLC/model/auth_token.dart';
import 'package:diuspeeder/auth_BLC/model/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xpath_selector/xpath_selector.dart';

class BLCApi {
  BLCApi() {
    _client = Dio(BaseOptions(baseUrl: BlcPath.baseUrl));
    _client.options.headers = <String, String>{
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.46 Safari/537.36',
    };
    presistCookie();
    // hiveInitial();

    // if (Platform.isAndroid) {
    //   _authstoken = FirebaseFirestore.instance;
    // }
  }

  late Dio _client;
  late Box diuSpeederDB;
  late Box userDatabox;
  late bool isSave;
  UserData _userData = UserData(
    firstname: '',
    lastname: '',
    userid: -1,
    fullname: '',
    username: '',
    userpictureurl: '',
    userprivateaccesskey: '',
  );

  AuthToken _authToken = AuthToken(
    token: '',
    privateToken: '',
    logintoken: '',
    user: '',
    pass: '',
    autoGenKey: '',
  );

  late PersistCookieJar cookieJar;
  bool isFirestoreDocId = false;

  UserData get userData {
    return _userData;
  }

  Future<void> presistCookie() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    if (kDebugMode) {
      print(appDocPath);
    }

    cookieJar = PersistCookieJar(
      storage: FileStorage('$appDocPath/.cookies/'),
    );

    // cookieJar = PersistCookieJar();
    _client.interceptors.add(CookieManager(cookieJar));
  }

  Future<void> hiveInitial() async {
    Hive.registerAdapter(AuthTokenAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserDataAdapter());

    diuSpeederDB = await Hive.openBox<dynamic>('diuSpeederDB');

    final dynamic authTokenGetBox = diuSpeederDB.get('AuthToken');
    if (authTokenGetBox != null) {
      _authToken = authTokenGetBox as AuthToken;
    }
    final dynamic userDataGetBox = diuSpeederDB.get('UserData');
    if (userDataGetBox != null) {
      _userData = userDataGetBox as UserData;
    }
  }

  Future<bool> login({
    required String user,
    required String pass,
    required bool isSave,
  }) async {
    this.isSave = isSave;
    if (kDebugMode) {
      print(diuSpeederDB.get('AuthToken'));
    }
    _authToken.user = user;
    _authToken.pass = pass;

    try {
      final responsed = await _client.post<dynamic>(
        BlcPath.apiLogin,
        queryParameters: <String, String>{
          'username': user,
          'password': pass,
          'service': 'moodle_mobile_app',
        },
        options: Options(
          followRedirects: false,
          contentType:
              ContentType.parse('application/json; charset=utf-8').toString(),
        ),
      );

      final responseJson = responsed.data as Map<String, dynamic>;
      if (responseJson.containsKey('token') &&
          responseJson.containsKey('privatetoken')) {
        _authToken.token = responseJson['token'] as String;
        _authToken.privateToken = responseJson['privatetoken'] as String;

        return true;
      }

      if (kDebugMode) {
        print(responseJson);
      }
    } on DioError catch (erro) {
      if (kDebugMode) {
        print(erro);
      }
      return false;
    }
    await saveThis();
    return false;
  }

  Future<UserData> getUser() async {
    final responsed = await _client.get<dynamic>(
      BlcPath.webserver,
      queryParameters: <String, dynamic>{
        'wstoken': _authToken.token,
        'wsfunction': 'core_webservice_get_site_info',
        'moodlewsrestformat': 'json',
      },
    );
    _userData.username = responsed.data['username'] as String;
    _userData.firstname = responsed.data['firstname'] as String;
    _userData.lastname = responsed.data['lastname'] as String;
    _userData.fullname = responsed.data['fullname'] as String;
    _userData.userid = responsed.data['userid'] as int;
    _userData.userpictureurl = responsed.data['userpictureurl'] as String;
    _userData.userprivateaccesskey =
        responsed.data['userprivateaccesskey'] as String;
    await saveThis();
    return _userData;
  }

  Future<void> autoLoginKeyGenarate() async {
    if (_authToken.autoGenKey.isEmpty) {
      final keyResponsed = await _client.post<dynamic>(
        BlcPath.webserver,
        data: <String, String>{
          'wsfunction': 'tool_mobile_get_autologin_key',
          'privatetoken': _authToken.privateToken,
          'wstoken': _authToken.token,
          'moodlewsrestformat': 'json',
        },
        options: Options(
          headers: <String, String>{
            'user-agent': 'MoodleMobile',
          },
          contentType: 'application/x-www-form-urlencoded',
        ),
      );
      if (kDebugMode) {
        print(keyResponsed.data);
      }
      _authToken.autoGenKey = keyResponsed.data['key'].toString();
    }
  }

  Future<void> apiAutoLogin() async {
    await autoLoginKeyGenarate();

    if (kDebugMode) {
      print(_authToken.autoGenKey);
      print(_userData.userid.toString());
    }

    await _client.get<dynamic>(
      BlcPath.autoLogin,
      queryParameters: <String, String>{
        'key': _authToken.autoGenKey,
        'userid': _userData.userid.toString(),
      },
      options: Options(
        extra: <String, String>{
          'accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
        },
        followRedirects: false,
        validateStatus: (i) => i! < 500,
      ),
    );
  }

  Future<void> webLogin() async {
    try {
      final tokenResponse = await _client.get<dynamic>(
        BlcPath.webLogin,
      );
      _authToken.logintoken = XPath.html(tokenResponse.data.toString())
          .query("//form[@id='login']/input[@name='logintoken']")
          .node!
          .attributes['value'];
      if (kDebugMode) {
        print(_authToken.logintoken);
      }
      await _client.post<dynamic>(
        BlcPath.webLogin,
        data: <String, String>{
          'username': _authToken.user,
          'password': _authToken.pass,
          'logintoken': _authToken.logintoken!,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
          followRedirects: false,
          contentType:
              ContentType.parse('application/x-www-form-urlencoded').toString(),
        ),
      );
    } on DioError catch (erro) {
      if (kDebugMode) {
        print(erro);
      }
    }
  }

  Future<bool> isWebLoginSuccess() async {
    try {
      final responsed = await _client.get<dynamic>(
        BlcPath.webLogin,
      );
      if (responsed.data.toString().contains(
            _userData.firstname,
          )) {
        return true;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  Future<bool> postVPL({
    required String pid,
    required String data,
    required String filename,
  }) async {
    filename = filename.isEmpty ? 'text.c' : filename;
    if (kDebugMode) {
      print(filename);
    }
    final getInfoResponse = await _client.post<dynamic>(
      BlcPath.vplPost,
      queryParameters: <String, String>{
        'id': pid,
        'action': 'load',
      },
    );
    final versionNumber = getInfoResponse.data['response']['version'] as String;
    final postResponsed = await _client.post<dynamic>(
      BlcPath.vplPost,
      queryParameters: <String, String>{
        'id': pid,
        'action': 'save',
      },
      data: <String, dynamic>{
        'file': '',
        'comments': '',
        'version': versionNumber,
        'files': [
          {
            'name': filename,
            'contents': data,
            'encoding': 0,
          }
        ]
      },
    );

    if (kDebugMode) {
      print(postResponsed);
    }
    await saveThis();
    if (postResponsed.data['success'] as bool) {
      if (kDebugMode) {
        print('success');
      }
      return true;
    }
    return false;
  }

  Future<void> saveThis() async {
    if (isSave) {
      if (_authToken.isAnyChange()) {
        await hiveSaveThis();
        _authToken.setAllCache();
      }
    }
  }

  Future<void> hiveSaveThis() async {
    await diuSpeederDB.put(
      'AuthToken',
      _authToken,
    );

    await diuSpeederDB.put(
      'UserData',
      _userData,
    );
  }

  Future<void> logout() async {
    await cookieJar.deleteAll();
    await diuSpeederDB.clear();
    _userData = UserData(
      firstname: '',
      lastname: '',
      userid: 0,
      fullname: '',
      username: '',
      userpictureurl: '',
      userprivateaccesskey: '',
    );
    _client.clear();
  }
}
