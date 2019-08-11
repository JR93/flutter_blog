// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleListData _$ArticleListDataFromJson(Map<String, dynamic> json) {
  return ArticleListData(
      json['code'] as int,
      json['message'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ArticleListDataToJson(ArticleListData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['total'] as int,
      (json['list'] as List)
          ?.map((e) => e == null
              ? null
              : ArticleData.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'total': instance.total, 'list': instance.list};

ArticleData _$ArticleDataFromJson(Map<String, dynamic> json) {
  return ArticleData(
      json['likeTotal'] as int,
      (json['tags'] as List)?.map((e) => e as String)?.toList(),
      json['pv'] as int,
      json['_id'] as String,
      json['title'] as String,
      json['subType'] as String,
      json['docType'] as String,
      json['content'] as String,
      json['createTime'] as String,
      json['updateTime'] as String,
      json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ArticleDataToJson(ArticleData instance) =>
    <String, dynamic>{
      'likeTotal': instance.likeTotal,
      'tags': instance.tags,
      'pv': instance.pv,
      '_id': instance.id,
      'title': instance.title,
      'subType': instance.subType,
      'docType': instance.docType,
      'content': instance.content,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'author': instance.author
    };

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return Author(json['_id'] as String, json['nick'] as String,
      json['name'] as String, json['avatar'] as String);
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      '_id': instance.id,
      'nick': instance.nick,
      'name': instance.name,
      'avatar': instance.avatar
    };
