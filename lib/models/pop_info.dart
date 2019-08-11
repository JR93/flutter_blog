class PopInfo {
  final int yyuid;

  PopInfo({this.yyuid});

  factory PopInfo.fromJson(Map<String, dynamic> json) {
    return PopInfo(
      yyuid: json['yyuid'],
    );
  }
}