import 'package:hive/hive.dart';

part 'auth_token.g.dart';

@HiveType(typeId: 1)
class AuthToken {
  AuthToken({
    required this.wstoken,
    required this.privateToken,
    required this.logintoken,
    required this.user,
    required this.pass,
    required this.autoGenKey,
    required this.isSave,
  });

  @HiveField(0)
  String wstoken;
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

  @HiveField(6)
  bool isSave;
  bool cIsSave = false;

  bool isAnyChange() {
    if (wstoken != cToken) {
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
    } else if (isSave != cIsSave) {
      return true;
    }
    return false;
  }

  void setAllCache() {
    cToken = wstoken;
    cPrivateToken = privateToken;
    cLogintoken = logintoken;
    cUser = user;
    cPass = pass;
    cAutoGenKey = autoGenKey;
    cIsSave = isSave;
  }

  @override
  String toString() {
    return toList().toString();
  }

  Map<String, dynamic> toList() => <String, dynamic>{
        'token': wstoken,
        'privateToken': privateToken,
        'logintoken': logintoken.toString(),
        'user': user,
        'pass': pass,
        'autoGenKey': autoGenKey,
        'isSave': isSave,
      };

  void clear(){
    wstoken = '';
    privateToken = '';
    logintoken = '';
    user = '';
    pass = '';
    autoGenKey = '';
    isSave = false;
    setAllCache();
  }
  
}
