
import 'package:hive/hive.dart';

part 'auth_token.g.dart';

@HiveType(typeId: 1)
class AuthToken {
  AuthToken({
    required this.token,
    required this.privateToken,
    required this.logintoken,
    required this.user,
    required this.pass,
    required this.autoGenKey,
  });

  @HiveField(0)
  String token;
  String cToken = '';

  @HiveField(1)
  String privateToken;
  String cPrivateToken = '';

  @HiveField(2)
  String? logintoken;
  String? cLogintoken = '';

  @HiveField(3)
  String user;
  String cUser = '';

  @HiveField(4)
  String pass;
  String cPass = '';

  @HiveField(5)
  String autoGenKey;
  String cAutoGenKey = '';

  bool isAnyChange() {
    if (token != cToken) {
      return true;
    } else if (privateToken != cPrivateToken) {
      return true;
    } else if (logintoken != cLogintoken) {
      return true;
    } else if (user != cUser) {
      return true;
    } else if (pass != cPass) {
      return true;
    } else if (autoGenKey != cAutoGenKey) {
      return true;
    }
    return false;
  }

  void setAllCache() {
    token = cToken;
    privateToken = cPrivateToken;
    logintoken = cLogintoken;
    user = cUser;
    pass = cPass;
    autoGenKey = cAutoGenKey;
  }

  @override
  String toString() {
    return 'Token $token PrivateToken $privateToken logintoken $logintoken '
        'user $user pass $pass $autoGenKey';
  }

  Map<String, String> toList() => {
        'token': token,
        'privateToken': privateToken,
        'logintoken': logintoken.toString(),
        'user': user,
        'pass': pass,
        'autoGenKey': autoGenKey,
      };
}
