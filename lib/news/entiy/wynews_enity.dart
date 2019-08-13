import 'package:json_annotation/json_annotation.dart';

part 'wynews_enity.g.dart';


@JsonSerializable()
class wynews_enity extends Object {

  @JsonKey(name: 'BBM54PGAwangning')
  List<BBM54PGAwangning> bBM54PGAwangning;

  wynews_enity(this.bBM54PGAwangning,);

  factory wynews_enity.fromJson(Map<String, dynamic> srcJson) => _$wynews_enityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$wynews_enityToJson(this);

}


@JsonSerializable()
class BBM54PGAwangning extends Object {

  @JsonKey(name: 'docid')
  String docid;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'priority')
  int priority;

  @JsonKey(name: 'hasImg')
  int hasImg;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'commentCount')
  int commentCount;

  @JsonKey(name: 'imgsrc3gtype')
  String imgsrc3gtype;

  @JsonKey(name: 'stitle')
  String stitle;

  @JsonKey(name: 'digest')
  String digest;

  @JsonKey(name: 'imgsrc')
  String imgsrc;

  @JsonKey(name: 'ptime')
  String ptime;

  BBM54PGAwangning(this.docid,this.source,this.title,this.priority,this.hasImg,this.url,this.commentCount,this.imgsrc3gtype,this.stitle,this.digest,this.imgsrc,this.ptime,);

  factory BBM54PGAwangning.fromJson(Map<String, dynamic> srcJson) => _$bbm4FromJson(srcJson);

  Map<String, dynamic> toJson() => _$BBM54PGAwangningToJson(this);

}
