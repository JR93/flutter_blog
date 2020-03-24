import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:zhiku/models/article_list_data.dart';
import 'package:zhiku/models/doc_list_data.dart';
import 'package:zhiku/models/user_info.dart';

const String BaseUrl = 'http://xxx.xxx.com/'; // Privacy protection

class Api {
  static Future<List<ArticleData>> getArticleList({ String lastDate = '', int count = 20 }) async {
    var params = {
      'data': {
        'count': count,
        'lastDate': lastDate
      }
    };
    var result;
    final response = await http.get('${BaseUrl}api/blog/getArticleList?data=${json.encode(params)}');
    if (response.statusCode == 200) {
      result = ArticleListData.fromJson(json.decode(response.body));
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return result?.data?.list??<ArticleData>[];
  }

  static Future<List<ArticleData>> getSearchList({ String query = '', String lastDate = '', int count = 20 }) async {
    var params = {
      'data': {
        'query': query,
        'count': count,
        'lastDate': lastDate
      }
    };
    var result;
    final response = await http.get('${BaseUrl}api/blog/getSearchList?data=${json.encode(params)}');
    if (response.statusCode == 200) {
      result = ArticleListData.fromJson(json.decode(response.body));
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return result?.data?.list??<ArticleData>[];
  }

  static Future<List<DocData>> getDocsList() async {
    var result;
    final response = await http.get('${BaseUrl}api/blog/getDocsList');
    if (response.statusCode == 200) {
      result = DocListData.fromJson(json.decode(response.body));
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return result?.data?.list??<DocData>[];
  }

  static Future<dynamic> getUserAvatar(int uid) async {
    var result;
    final response = await http.get('http://x.xx.com//lite/task/user/query?uid=$uid');
    if (response.statusCode == 200) {
      result = UserInfo.fromJson(json.decode(response.body));
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return result;
  }
}
