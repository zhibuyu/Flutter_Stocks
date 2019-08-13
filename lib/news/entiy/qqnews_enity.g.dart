// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qqnews_enity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

qqnews_enity _$qqnews_enityFromJson(Map<String, dynamic> json) {
  return qqnews_enity(
    json['error_code'] as int,
    (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['reason'] as String,
  );
}

Map<String, dynamic> _$qqnews_enityToJson(qqnews_enity instance) =>
    <String, dynamic>{
      'error_code': instance.errorCode,
      'data': instance.data,
      'reason': instance.reason,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['title'] as String,
    json['time'] as String,
    json['column'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'title': instance.title,
      'time': instance.time,
      'column': instance.column,
      'url': instance.url,
    };
