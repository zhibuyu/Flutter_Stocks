/**
 * @Description  TODO
 * @Author  zhibuyu
 * @Date 2018/10/12  14:13
 * @Version  1.0
 */
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:mystocks/Util/StringUtil.dart';
import 'package:mystocks/Util/TimeUtils.dart';
import 'package:mystocks/news/NewsWebPage.dart';
import 'package:mystocks/news/entiy/news_enity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FinanceNewsPage extends StatefulWidget {
  FinanceNewsPage({Key key}) : super(key: key);

  @override
  FinanceNewsPageState createState() => new FinanceNewsPageState();
}

class FinanceNewsPageState extends State<FinanceNewsPage> {
  List<Data> listData = new List();
  bool loaded = false;

  var listTotalSize = 0;

  int lastone_id = 0;
  bool has_next_page;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  ScrollController controller = new ScrollController();

  FinanceNewsPageState() {
    controller.addListener(() {
      var maxScroll = controller.position.maxScrollExtent;
      var pixels = controller.position.pixels;
//      if (maxScroll == pixels && listData.length < listTotalSize) {
      if (maxScroll == pixels) {
        // scroll to bottom, get next page data
        //加载更多
        print("加载更多开始---");
//        curPage++;
//        getNewsList(true);
        getDatas(true);
      }
    });
//    getDatas();
  }

  @override
  void initState() {
    super.initState();
    print("新闻列表initState ... ");
    getDatas(false);
  }

  showLoadingDialog() {
    return !loaded;
//    if(loaded=true){
//
//    }
//    if (widgets == null) {
//      return true;
//    } else if (widgets.length == 0) {
//      return true;
//    }
//
//    return false;
  }

  getBody() {
//    if (showLoadingDialog()) {
//      return getProgressDialog();
//    } else {
//      Widget listView = getListView();
//      return new Container(
//        padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//        child: new RefreshIndicator(child: listView, onRefresh: pullToRefresh),
//      );
//    }
    if (listData == null) {
      return getProgressDialog();
    } else {
      Widget listView = getListView();
      return new RefreshIndicator(
        key: _refreshIndicatorKey,
          child: listView, onRefresh: pullToRefresh);
    }
  }

  getProgressDialog() {
    // CircularProgressIndicator是一个圆形的Loading进度条
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: getBody(),
    );
  }

  ListView getListView() => new ListView.builder(
        itemCount: (listData == null) ? 0 : listData.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position);
        },
        physics: new AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: controller,
      );

  /**
   * 列表item
   */
  Widget getRow(int i) {
    print("加载列表getRow==》" + i.toString());
    String articleTitle = listData[i].articleTitle;
    int time = listData[i].time;
    String time_str = readTimestamp(time);
    return new GestureDetector(
        child: Padding(
//      padding: new EdgeInsets.all(10.0),
          padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: new Column(
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start, //纵向对齐方式：起始边对齐
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Expanded(
                    child: Container(
                      height: 95.0,
                      child: getImage(i),
                      alignment: FractionalOffset.center,
                    ),
                    flex: 1,
                  ),
                  new Expanded(
                    child: Container(
                      height: 95.0,
                      margin: new EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            child: new Text(
                              articleTitle,
                              style: new TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            alignment: FractionalOffset.topLeft,
                          ),
                          new Container(
                            child: new Text("${listData[i].articleBrief}",
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
                                    child: new Text(
                                        "${listData[i].articleAuthor}",
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

  void getDatas(bool isLoadMore) async {
//    List<Data> datas;
    String query;
    if (!isLoadMore) {
      query ="source(limit: 10,sort:\"desc\"),{data{}, page_info{has_next_page, end_cursor}}";
    } else {
      query = "source(limit: 10,__id:{gte:${lastone_id},lte:${lastone_id + 10}},sort:\"desc\"),{data{}, page_info{has_next_page, end_cursor}}";
    }
    String url=GetFinanceNewsUrl(query);
    print("请求的url===》" + url);
    Dio dio = new Dio();
    Response response = await dio.get(url);
    var jsonString = response.data;
    print("jsonString==>" + jsonString.toString());
//    try {
      var news = new news_enity.fromJson(jsonString);
      var code = news.code;
      if (code == 0) {
        Result result = news.result;
        setState(() {
          if (!isLoadMore) {
            // 不是加载更多，则直接为变量赋值
//          datas.clear();
            listData = result.data;
          } else {
            // 是加载更多，则需要将取到的news数据追加到原来的数据后面
            List list1 = new List();
            list1.addAll(listData);
            list1.addAll(result.data);
            // 判断是否获取了所有的数据，如果是，则需要显示底部的"我也是有底线的"布局
            if (list1.length >= listTotalSize) {
              list1.add("COMPLETE");
            }
          }
        });
        lastone_id = result.pageInfo.endCursor;
        has_next_page = result.pageInfo.hasNextPage;
        Fluttertoast.showToast(
            msg: "请求成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,bgcolor: "#OOOOOO",textcolor: '#ffffff'
        );
      }else{
        Fluttertoast.showToast(
            msg: news.error_info,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,bgcolor: "#OOOOOO",textcolor: '#ffffff'
        );
      }

//    } catch (e) {
//      Fluttertoast.showToast(
//          msg: "异常："+e.toString(),
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,bgcolor: "#e74c3c",textcolor: '#ffffff'
//      );
//      print("异常==》" + e.toString());
//    }
//    loaded = true;

  }

  getImage(int i) {
//    print("加载图片getImage==》" + i.toString());
    String img_url = listData[i].articleThumbnail;
    return new CachedNetworkImage(
      imageUrl: img_url,
//      placeholder: new CircularProgressIndicator(),
      errorWidget: new Icon(Icons.error),
      fit: BoxFit.cover,
      height: 85.0,
      width: 100.0,
    );
  }

  /**
   * 列表点击
   */
  void onItemClick(int i, String articleTitle) {
    String h5_url = listData[i].url;
    print("列表点击=h5_url=》" + h5_url);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new NewsWebPage(h5_url, articleTitle)));

//    new WebPage(h5_url,articleTitle);
//    final  flutterWebviewPlugin = new FlutterWebviewPlugin();
//    flutterWebviewPlugin.launch(h5_url, hidden: true);
    print("列表点击==》" + i.toString());
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  /**
   *下拉刷新
   */
  Future<Null> pullToRefresh() async{
    lastone_id = 0;
    getDatas(false);
    print("刷新完成--------");
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}
