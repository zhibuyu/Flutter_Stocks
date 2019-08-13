// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wynews_enity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

wynews_enity _$wynews_enityFromJson(Map<String, dynamic> json) {
  return wynews_enity(
    (json['BBM54PGAwangning'] as List)
        ?.map((e) => e == null
            ? null
            : BBM54PGAwangning.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$wynews_enityToJson(wynews_enity instance) =>
    <String, dynamic>{
      'BBM54PGAwangning': instance.bBM54PGAwangning,
    };

BBM54PGAwangning _$bbm4FromJson(Map<String, dynamic> json) {
  return BBM54PGAwangning(
    json['docid'] as String,
    json['source'] as String,
    json['title'] as String,
    json['priority'] as int,
    json['hasImg'] as int,
    json['url'] as String,
    json['commentCount'] as int,
    json['imgsrc3gtype'] as String,
    json['stitle'] as String,
    json['digest'] as String,
    json['imgsrc'] as String,
    json['ptime'] as String,
  );
}

Map<String, dynamic> _$BBM54PGAwangningToJson(BBM54PGAwangning instance) =>
    <String, dynamic>{
      'docid': instance.docid,
      'source': instance.source,
      'title': instance.title,
      'priority': instance.priority,
      'hasImg': instance.hasImg,
      'url': instance.url,
      'commentCount': instance.commentCount,
      'imgsrc3gtype': instance.imgsrc3gtype,
      'stitle': instance.stitle,
      'digest': instance.digest,
      'imgsrc': instance.imgsrc,
      'ptime': instance.ptime,
    };
