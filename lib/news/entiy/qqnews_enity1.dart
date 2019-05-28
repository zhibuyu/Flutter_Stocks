/**
 * @Description  TODO
 * @Author  zhibuyu
 * @Date 2019/5/28  9:13
 * @Version  1.0
 */

import 'package:json_annotation/json_annotation.dart';

part 'qqnews_enity1.g.dart';


@JsonSerializable()
class qqnews_enity1 extends Object {

  @JsonKey(name: 'error_code')
  int errorCode;

  @JsonKey(name: 'data')
  Data1 data;

  @JsonKey(name: 'reason')
  String reason;

  qqnews_enity1(this.errorCode,this.data,this.reason,);

  factory qqnews_enity1.fromJson(Map<String, dynamic> srcJson) => _$qqnews_enity1FromJson(srcJson);

  Map<String, dynamic> toJson() => _$qqnews_enity1ToJson(this);

}


@JsonSerializable()
class Data1 extends Object {

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'column')
  String column;

  @JsonKey(name: 'url')
  String url;

  Data1(this.title,this.time,this.column,this.url,);

  factory Data1.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

