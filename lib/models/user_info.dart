class UserInfo {
  final int code;
  final String message;
  final Data data;

  UserInfo({this.code, this.message, this.data});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      code: json['code'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String nick;
  final String headPic;

  Data({this.nick, this.headPic});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      nick: json['nick'],
      headPic: json['headPic'],
    );
  }
}