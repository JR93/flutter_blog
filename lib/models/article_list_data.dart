import 'package:json_annotation/json_annotation.dart'; 
  
part 'article_list_data.g.dart';


@JsonSerializable()
  class ArticleListData extends Object {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'data')
  Data data;

  ArticleListData(this.code,this.message,this.data,);

  factory ArticleListData.fromJson(Map<String, dynamic> srcJson) => _$ArticleListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ArticleListDataToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'list')
  List<ArticleData> list;

  Data(this.total,this.list,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
@JsonSerializable()
  class ArticleData extends Object {

  @JsonKey(name: 'likeTotal')
  int likeTotal;

  @JsonKey(name: 'tags')
  List<String> tags;

  @JsonKey(name: 'pv')
  int pv;

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'subType')
  String subType;

  @JsonKey(name: 'docType')
  String docType;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'author')
  Author author;

  ArticleData(this.likeTotal,this.tags,this.pv,this.id,this.title,this.subType,this.docType,this.content,this.createTime,this.updateTime,this.author,);

  factory ArticleData.fromJson(Map<String, dynamic> srcJson) => _$ArticleDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ArticleDataToJson(this);

}

  
@JsonSerializable()
  class Author extends Object {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'nick')
  String nick;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'avatar')
  String avatar;

  Author(this.id,this.nick,this.name,this.avatar,);

  factory Author.fromJson(Map<String, dynamic> srcJson) => _$AuthorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);

}

  
