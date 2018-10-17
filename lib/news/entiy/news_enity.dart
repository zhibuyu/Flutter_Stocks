import 'package:json_annotation/json_annotation.dart';

part 'news_enity.g.dart';


@JsonSerializable()
class news_enity extends Object {

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'result')
  Result result;

  news_enity(this.code,this.result,);

  factory news_enity.fromJson(Map<String, dynamic> srcJson) => _$news_enityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$news_enityToJson(this);

}


@JsonSerializable()
class Result extends Object {

  @JsonKey(name: 'data')
  List<Data> data;

  Result(this.data,);

  factory Result.fromJson(Map<String, dynamic> srcJson) => _$ResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);

}


@JsonSerializable()
class Data extends Object {

  @JsonKey(name: 'article_title')
  String articleTitle;

  @JsonKey(name: 'article_brief')
  String articleBrief;

  @JsonKey(name: 'article_content')
  String articleContent;

  @JsonKey(name: 'article_author')
  String articleAuthor;

  @JsonKey(name: 'article_avatar')
  String articleAvatar;

  @JsonKey(name: 'article_publish_time')
  String articlePublishTime;

  @JsonKey(name: 'article_thumbnail')
  String articleThumbnail;

  @JsonKey(name: 'article_categories')
  List<String> articleCategories;

  @JsonKey(name: 'comment')
  String comment;

  @JsonKey(name: '__id')
  int id;

  @JsonKey(name: '__time')
  int time;

  @JsonKey(name: '__url')
  String url;

  Data(this.articleTitle,this.articleBrief,this.articleContent,this.articleAuthor,this.articleAvatar,this.articlePublishTime,this.articleThumbnail,this.articleCategories,this.comment,this.id,this.time,this.url,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


