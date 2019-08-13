import 'dart:convert';

/**
 * @Description  TODO
 * @Author  zhibuyu
 * @Date 2018/10/12  14:13
 * @Version  1.0
 */
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:mystocks/Util/Constants.dart';
import 'package:mystocks/news/NewsWebPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:convert/convert.dart';
import 'package:convert/convert.dart';
import 'entiy/ListEnity.dart';
import 'entiy/wynews_enity.dart';

/**
 * 网易新闻页面
 */
class WyNewsPage extends StatefulWidget {
  WyNewsPage({Key key}) : super(key: key);

  @override
  WyNewsPageState createState() => new WyNewsPageState();
}

class WyNewsPageState extends State<WyNewsPage> {
  List<ListEnity> listData = [];
  int lastone_id;
  int lastone_id_start = 0;
  int lastone_id_end = 0;
  bool has_next_page = true;

  bool issuccessful = true;
  var start_index =0 ;
  var end_index =10;

  @override
  void initState() {
    super.initState();
    getDatas(START_REQUEST);
  }

  getBody() {
    if(issuccessful ==true ){
      if (listData.isEmpty) {
        // 加载菊花
        return CircularProgressIndicator();
      } else {
        return new Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: pullToRefresh,
            child: ListView.builder(
              itemCount: (listData == null) ? 0 : listData.length,
              itemBuilder: (BuildContext context, int position) {
                return getItem(position);
              },
              physics: new AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
            ));
      }
    }else{
      return new Refresh(
          onFooterRefresh: onFooterRefresh,
          onHeaderRefresh: pullToRefresh,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int position) {
              return Center(
                child: new Text("异常", style: new TextStyle(fontSize: 40.0, color: Colors.black)),
              );
            },
            physics: new AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: getBody(),
    );
  }


  /**
   * 列表item
   */
  Widget getItem(int i) {
//    print("加载列表getRow==》" + i.toString());
    BBM54PGAwangning data = listData[i].data;
    String type = listData[i].type;
    if ("main" == type) {
      String articleTitle = data.title;
      String time_str = data.ptime;
      return new GestureDetector(
          child: Padding(
            padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start, //纵向对齐方式：起始边对齐
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Expanded(
                      child: Container(
                        height: 100.0,
                        child: getImage(data.imgsrc),
                        alignment: FractionalOffset.center,
                      ),
                      flex: 1,
                    ),
                    new Expanded(
                      child: Container(
                        height: 100.0,
                        margin: new EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                articleTitle,
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              alignment: FractionalOffset.topLeft,
                            ),
                            new Container(
                              child: new Text("${data.digest}",
                                  style: new TextStyle(fontSize: 16.0),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              alignment: Alignment.topLeft,
                            ),
                            new Expanded(
                              child: new Container(
                                margin:
                                    new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                child: new Stack(
                                  children: <Widget>[
                                    new Container(
                                      child: new Text("${data.source}",
                                          style: new TextStyle(fontSize: 10.0)),
                                      alignment: FractionalOffset.bottomLeft,
                                    ),
                                    new Container(
                                      child: new Text(time_str,
                                          style: new TextStyle(fontSize: 10.0)),
                                      alignment: FractionalOffset.bottomRight,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                new Divider(), //分割线
              ],
            ),
          ),
          onTap: () {
            onItemClick(i, articleTitle);
          });
    } else {
      print("加载底线");
      return new Container(
        height: 50.0,
        child: new Text(
          "——   我也是有底线的   ——",
          style: new TextStyle(fontSize: 16.0, color: Colors.black38),
        ),
        alignment: FractionalOffset.center,
      );
    }
  }

  /**
   * 请求数据
   * isLoadMore 是否为加载更多
   */
  void getDatas(int request_type) async {
    if(request_type ==REFRESH_REQIEST){
      start_index = 0;
      end_index = 10;
    }
    String url = "https://3g.163.com/touch/reconstruct/article/list/BBM54PGAwangning/"+start_index.toString()+"-"+end_index.toString()+".html";
    print("请求的url===》" + url);
    Dio dio = new Dio();
    Response response = await dio.get(url);
    String response_str = response.data;
    if(response_str.isNotEmpty){
      var jsonString = response_str.substring("artiList(".length,response_str.length-1);
      print("请求后的jsonString===》" + jsonString);
      Map<String, dynamic> responseJson =  json.decode(jsonString);
      DealDatas(responseJson, request_type);
      start_index = end_index+1;
      end_index = start_index+9;
    }else{
      Fluttertoast.showToast(
          msg: "已经没有新数据了",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }

  }

  /**
   * 列表中图片加载
   */
  getImage(String img_url) {
    return new
    CachedNetworkImage(
      imageUrl: img_url,
      placeholder: (context, url) => new Center(
        child: CircularProgressIndicator(),
      ) ,
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
  }

  /**
   * 列表点击
   */
  void onItemClick(int i, String articleTitle) {
    String h5_url = (listData[i].data as BBM54PGAwangning).url;
    String title= (listData[i].data as BBM54PGAwangning).title;
    Navigator.push(
        context,
        new MaterialPageRoute(
//            builder: (context) => new NewsWebPage(h5_url,'新闻详情')));
            builder: (context) => new NewsWebPage(h5_url,title)));
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  /**
   *下拉刷新
   */
  Future<Null> pullToRefresh() async {
    getDatas(REFRESH_REQIEST);
    return null;
  }

  Future<Null> onFooterRefresh() async {
    getDatas(LOADMORE_REQIEST);
  }

  /**
   * 处理请求到的数据
   */
  void DealDatas(jsonString, int request_type) {
    try {
      var news = new wynews_enity.fromJson(jsonString);
      setState(() {
        if(request_type==REFRESH_REQIEST){
          listData.clear();
          for (BBM54PGAwangning data in news.bBM54PGAwangning) {
            ListEnity listEnity = new ListEnity("main",data);
            listData.add(listEnity);
          }
          Fluttertoast.showToast(
              msg: "刷新成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }else{
          List<ListEnity> list1 = new List<ListEnity>();
          list1.addAll(listData);
          for (BBM54PGAwangning data in news.bBM54PGAwangning) {
            ListEnity listEnity = new ListEnity("main", data);
            list1.add(listEnity);
          }
          listData = list1;
        }
      });
    } catch (e) {
      setState(() {
        issuccessful = false;
      });
      print("异常==》" + e.toString());
    }
  }
}
