/**
 * @Description  md5 加密工具类
 * @Author  zhibuyu
 * @Date 2018/10/19  11:29
 * @Version  1.0
 */
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

String StringToMd5(String str){
  String deal_str=md5.convert(utf8.encode(str)).toString();
  return deal_str;
}

