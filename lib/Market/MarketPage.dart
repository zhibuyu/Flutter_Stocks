import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/**
 * @Description  行情界面
 * @Author  zhibuyu
 * @Date 2018/10/25  10:27
 * @Version  1.0
 */
bool isFirstin; //第一次进入
class MarketPage extends StatefulWidget{



  MarketPage(){
    isFirstin=true;
  }


  @override
  State<StatefulWidget> createState() =>new MarketPageState();


}
class MarketPageState extends State<MarketPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Text("行情");
  }

  @override
  void initState() {
    if(isFirstin){
      getDatas();
      isFirstin=false;
    }
  }

  void getDatas() async{
    String url = "http://hq.sinajs.cn/list=sh601003,sh601001,sz002242,sz002230,sh603456,sz002736,sh600570";
    print("请求的url===》" + url);
    Dio dio = new Dio();
    Response response = await dio.get(url);
    var data_str = response.data;
    print("获取到的数据data_str==》"+data_str);
  }




}