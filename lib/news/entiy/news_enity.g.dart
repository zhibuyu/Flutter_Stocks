// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_enity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

news_enity _$news_enityFromJson(Map<String, dynamic> json) {
  return news_enity(
      json['code'] as int,
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>))
    ..error_info = json['error_info'] as String;
}

Map<String, dynamic> _$news_enityToJson(news_enity instance) =>
    <String, dynamic>{
      'code': instance.code,
      'error_info': instance.error_info,
      'result': instance.result
    };

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Data.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['page_info'] == null
          ? null
          : Page_info.fromJson(json['page_info'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ResultToJson(Result instance) =>
    <String, dynamic>{'data': instance.data, 'page_info': instance.pageInfo};

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['article_title'] as String,
      json['article_brief'] as String,
      json['article_content'] as String,
      json['article_author'] as String,
      json['article_avatar'] as String,
      json['article_publish_time'] as String,
      json['article_thumbnail'] as String,
      (json['article_categories'] as List)?.map((e) => e as String)?.toList(),
      json['comment'] as String,
      json['__id'] as int,
      json['__time'] as int,
      json['__url'] as String);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'article_title': instance.articleTitle,
      'article_brief': instance.articleBrief,
      'article_content': instance.articleContent,
      'article_author': instance.articleAuthor,
      'article_avatar': instance.articleAvatar,
      'article_publish_time': instance.articlePublishTime,
      'article_thumbnail': instance.articleThumbnail,
      'article_categories': instance.articleCategories,
      'comment': instance.comment,
      '__id': instance.id,
      '__time': instance.time,
      '__url': instance.url
    };

Page_info _$Page_infoFromJson(Map<String, dynamic> json) {
  return Page_info(json['has_next_page'] as bool, json['end_cursor'] as int);
}

Map<String, dynamic> _$Page_infoToJson(Page_info instance) => <String, dynamic>{
      'has_next_page': instance.hasNextPage,
      'end_cursor': instance.endCursor
    };
