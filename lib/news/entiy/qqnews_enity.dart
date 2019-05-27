import 'package:json_annotation/json_annotation.dart'; 
  
part 'qqnews_enity.g.dart';


@JsonSerializable()
  class qqnews_enity extends Object {

  @JsonKey(name: 'error_code')
  int errorCode;

  @JsonKey(name: 'data')
  List<Data> data;

  @JsonKey(name: 'reason')
  String reason;

  qqnews_enity(this.errorCode,this.data,this.reason,);

  factory qqnews_enity.fromJson(Map<String, dynamic> srcJson) => _$qqnews_enityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$qqnews_enityToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'column')
  String column;

  @JsonKey(name: 'url')
  String url;

  Data(this.title,this.time,this.column,this.url,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
