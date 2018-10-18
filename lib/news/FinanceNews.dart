/**
 * @Description  TODO
 * @Author  zhibuyu
 * @Date 2018/10/12  14:13
 * @Version  1.0
 */
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:mystocks/Util/TimeUtils.dart';
import 'package:mystocks/news/entiy/news_enity.dart';
import 'package:mystocks/widget/webview.dart';

class FinanceNewsPage extends StatefulWidget {
  FinanceNewsPage({Key key}) : super(key: key);

  @override
  FinanceNewsPageState createState() => new FinanceNewsPageState();
}

class FinanceNewsPageState extends State<FinanceNewsPage> {
  List<Data> widgets = new List();
  bool loaded = false;

  FinanceNewsPageState() {
    getDatas();
  }

  @override
  void initState() {
    super.initState();
//    getDatas();
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
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return new Container(
        padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: getListView(),
      );
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: getBody(),
    );
  }

  ListView getListView() => new ListView.builder(
      itemCount: (widgets == null) ? 0 : widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  /**
   * 列表item
   */
  Widget getRow(int i) {
    print("加载列表getRow==》" + i.toString());
    String articleTitle=widgets[i].articleTitle;
    int time = widgets[i].time;
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
                            child: new Text("${widgets[i].articleBrief}",
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
                                        "${widgets[i].articleAuthor}",
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
        onTap : () {
          onItemClick(i,articleTitle);
        });
  }

  void getDatas() async {
    List<Data> datas;
    String url =
        "https://graphql.shenjian.io/?user_key=e66f2652b0-NDlmNDhmOT&timestamp=1539428428233&sign=9cb7d1ba1ce8facb996b254d42415941&source_id=2358538&query=source(limit:20){}";
    print("请求的url===》" + url);
    Dio dio = new Dio();
    Response response = await dio.get(url);
    var jsonString = response.data;
    print("jsonString==>" + jsonString.toString());
    try {
      var news = new news_enity.fromJson(jsonString);
      var code = news.code;
      if (code == 0) {
        Result result = news.result;
        datas = result.data;
      }
      print("数据datas==》" + datas.toString());
    } catch (e) {
      print("异常==》" + e.toString());
    }
    loaded = true;
    setState(() {
      widgets = datas;
    });
  }

  getImage(int i) {
    print("加载图片getImage==》" + i.toString());
    String img_url = widgets[i].articleThumbnail;
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
  void onItemClick(int i,String articleTitle) {
    String h5_url=widgets[i].url;
    print("列表点击=h5_url=》"+h5_url);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new WebPage(h5_url,articleTitle)));

//    new WebPage(h5_url,articleTitle);
//    final  flutterWebviewPlugin = new FlutterWebviewPlugin();
//    flutterWebviewPlugin.launch(h5_url, hidden: true);
    print("列表点击==》"+i.toString());
  }
}
