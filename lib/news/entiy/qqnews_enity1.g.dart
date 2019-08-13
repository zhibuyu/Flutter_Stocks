// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qqnews_enity1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

qqnews_enity1 _$qqnews_enity1FromJson(Map<String, dynamic> json) {
  return qqnews_enity1(
    json['error_code'] as int,
    json['data'] == null
        ? null
        : Data1.fromJson(json['data'] as Map<String, dynamic>),
    json['reason'] as String,
  );
}

Map<String, dynamic> _$qqnews_enity1ToJson(qqnews_enity1 instance) =>
    <String, dynamic>{
      'error_code': instance.errorCode,
      'data': instance.data,
      'reason': instance.reason,
    };

Data1 _$Data1FromJson(Map<String, dynamic> json) {
  return Data1(
    json['title'] as String,
    json['time'] as String,
    json['column'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$Data1ToJson(Data1 instance) => <String, dynamic>{
      'title': instance.title,
      'time': instance.time,
      'column': instance.column,
      'url': instance.url,
    };
