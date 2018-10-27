/**
 * @Description  字符串工具类
 * @Author  zhibuyu
 * @Date 2018/10/24  9:25
 * @Version  1.0
 */

import 'package:mystocks/Util/MD5Utils.dart';
/**
 * 获取财经新闻请求url
 */
String GetFinanceNewsUrl(String query){
  String user_key = "e66f2652b0-NDlmNDhmOT";
  var now = new DateTime.now();
  String time = now.millisecondsSinceEpoch.toString();
  String secret_key = "llNjZmMjY1MmIwNT-58ba0f5e5a49f48";
  String md5_str = StringToMd5(user_key + time + secret_key);
  String source_id = "2358538";
  String news_url = "https://graphql.shenjian.io/?user_key=" +user_key +"&timestamp=" + time +"&sign=" +md5_str +"&source_id=" +source_id +"&query=" +query;
  return news_url;
}
