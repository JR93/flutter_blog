
class DocListData {
  final int code;
  final String message;
  final Data data;

  DocListData({this.code, this.message, this.data});

  factory DocListData.fromJson(Map<String, dynamic> json) {
    return DocListData(
      code: json['code'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final int total;
  final List<DocData> list;

  Data({this.total, this.list});

  factory Data.fromJson(Map<String, dynamic> json) {
    var listJson = json['list'] as List;
    List<DocData> list = listJson.map((i) => DocData.fromJson(i)).toList();

    return Data(
      total: json['total'],
      list: list,
    );
  }
}

class DocData {
  final String id;
  final String title;
  final String docType;

  DocData({this.id, this.title, this.docType});

  factory DocData.fromJson(Map<String, dynamic> json) {
    return DocData(
      id: json['_id'],
      title: json['title'],
      docType: json['docType'],
    );
  }
}