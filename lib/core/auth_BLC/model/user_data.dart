import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 2)
class UserData {
  UserData({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.fullname,
    required this.userid,
    required this.userpictureurl,
    required this.userprivateaccesskey,
  });
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String firstname;

  @HiveField(2)
  late String lastname;

  @HiveField(3)
  late String fullname;

  @HiveField(4)
  late int userid;

  @HiveField(5)
  late String userpictureurl;

  @HiveField(6)
  late String userprivateaccesskey;

  Map<String, String> toList() => {
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'fullname': fullname,
        'userid': userid.toString(),
        'userpictureurl': userpictureurl,
        'userprivateaccesskey': userprivateaccesskey,
      };

  @override
  String toString() {
    return toList().toString();
  }

  void clear() {
    firstname = '';
    lastname = '';
    userid = -1;
    fullname = '';
    username = '';
    userpictureurl = '';
    userprivateaccesskey = '';
  }
}
