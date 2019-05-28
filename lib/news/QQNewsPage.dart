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
import 'package:mystocks/news/entiy/qqnews_enity.dart';
import 'package:mystocks/news/entiy/qqnews_enity1.dart';
/**
 * 腾讯新闻页面
 */
class QQNewsPage extends StatefulWidget {
  QQNewsPage({Key key}) : super(key: key);

  @override
  QQNewsPageState createState() => new QQNewsPageState();
}

class QQNewsPageState extends State<QQNewsPage> {
  List<Data> listData = [];
//  int lastone_id;
//  int lastone_id_start = 0;
//  int lastone_id_end = 0;
  bool has_next_page = false;
  @override
  void initState() {
    super.initState();
    getDatas(START_REQUEST);
  }

  getBody() {
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
    Data data = listData[i];
    String articleTitle = data.title;
    String time_str = data.time;
    return new GestureDetector(
        child: Padding(
          padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: new Column(
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start, //纵向对齐方式：起始边对齐
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
//                    new Expanded(
//                      child: Container(
//                        height: 95.0,
//                        child: getImage(data.articleThumbnail),
//                        alignment: FractionalOffset.center,
//                      ),
//                      flex: 1,
//                    ),
                  new Expanded(
                    child: Container(
                      height: 55.0,
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
//                            new Container(
//                              child: new Text("${data.articleBrief}",
//                                  style: new TextStyle(fontSize: 16.0),
//                                  maxLines: 2,
//                                  overflow: TextOverflow.ellipsis),
//                              alignment: Alignment.topLeft,
//                            ),
                          new Expanded(
                            child: new Container(
                              margin:
                              new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    child: new Text("${data.column}",
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
  }

  /**
   * 请求数据
   * isLoadMore 是否为加载更多
   */
  void getDatas(int request_type) async {
    String url = "https://api.shenjian.io/?appid=af7dabcf2baff628a2935cb89aaffd72";
    print("请求的url===》" + url);
    Dio dio = new Dio();
    Response response = await dio.get(url);
    var jsonString = response.data;
    DealDatas(jsonString, request_type);
  }

  /**
   * 列表中图片加载
   */
  getImage(String img_url) {
    return new
    CachedNetworkImage(
      imageUrl: img_url,
      placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
  }

  /**
   * 列表点击
   */
  void onItemClick(int i, String articleTitle) {
    String h5_url = (listData[i] as Data).url;
    print("打开的H5-url++>"+h5_url);
    String title= (listData[i] as Data).title;
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
      var news = new qqnews_enity.fromJson(jsonString);
      var code = news.errorCode;
      if (code == 0) {
        setState(() {
          listData = news.data;
          if(request_type==REFRESH_REQIEST){
            Fluttertoast.showToast(
                msg: "刷新成功",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white);
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "数据源异常",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }
    } catch (e) {
      try {
        var news1 = new qqnews_enity1.fromJson(jsonString);
        var code = news1.errorCode;
        if (code == 0) {
          setState(() {
            Data1 data1 = news1.data;
            if(data1 != null){
              Data data = new Data(data1.title, data1.time, data1.column, data1.url);
              listData.add(data);
              if(request_type==REFRESH_REQIEST){
                Fluttertoast.showToast(
                    msg: "刷新成功",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white);
              }
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "数据源异常",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      } catch (e) {
        print("异常==》" + e.toString());
      }
    }
  }
}
