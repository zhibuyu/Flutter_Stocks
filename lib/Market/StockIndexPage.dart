import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystocks/Market/enity/StockIndex.dart';
import 'package:mystocks/Util/Constants.dart';

/**
 * @Description  指数
 * @Author  zhibuyu
 * @Date 2018/10/25  10:26
 * @Version  1.0
 */

class StockIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new StockIndexPageState();
}

class StockIndexPageState extends State<StockIndexPage> {
  List<StockIndex> listData = [];

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: getBody(),
    );
  }

  @override
  void initState() {
    getDatas(START_REQUEST);
  }

  getBody() {
    if (listData.isEmpty) {
      // 加载菊花
      return CircularProgressIndicator();
    } else {
      return new Container(
        child: new RefreshIndicator(
            child: getGistView(), onRefresh: pullToRefresh),
        alignment: FractionalOffset.topLeft,
      );
    }
  }

  Future<Null> pullToRefresh() async {
    getDatas(REFRESH_REQIEST);
    return null;
  }

  void getDatas(int request_type)  {
    String url =
        "http://hq.sinajs.cn/list=s_sz399001,s_sh000002,s_sh000003,s_sh000008,s_sh000009,s_sh000010,s_sh000011,s_sh000012,s_sh000016,"
        "s_sh000017,s_sh000300,s_sh000905,s_sz399001,s_sz399002,s_sz399003,s_sz399004,s_sz399005,s_sz399006,s_sz399008,s_sz399100,"
        "s_sz399101,s_sz399106,s_sz399107,s_sz399108,s_sz399333,s_sz399606";
    fetch(url).then((data) {
      setState(() {
        List<String> index_strs = data.split(";");
        setState(() {
          for (int i = 0; i < (index_strs.length - 1); i++) {
            String str = index_strs[i];
            StockIndex stockIndex = new StockIndex();
            DealStockIndess(str, stockIndex);
            listData.add(stockIndex);
          }
          if (request_type == REFRESH_REQIEST) {
            Fluttertoast.showToast(
                msg: "刷新成功",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                bgcolor: "#OOOOOO",
                textcolor: '#ffffff');
          }
        });
      });
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: "网络异常，请检查",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          bgcolor: "#OOOOOO",
          textcolor: '#ffffff');
    });

  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }

  getGistView() {
    return new GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(5.0),
      //主轴间隔
      mainAxisSpacing: 0.0,
      //横轴间隔
      crossAxisSpacing: 0.0,
      children: buildGridList(),
    );
  }

  buildGridList() {
    List<Widget> widgetList = new List();
    for (StockIndex stockIndex in listData) {
      widgetList.add(getItemWidget(stockIndex));
    }
    return widgetList;
  }

  Widget getItemWidget(StockIndex stockIndex) {
    Color show_color;
    String gains_rate = stockIndex.gains_rate;
    String change_prefix="";
    if (gains_rate == "0.00") {
      show_color = Colors.black38;
    } else {
      if (gains_rate.indexOf("-") == -1) {
        change_prefix="+";
        show_color = Colors.red;
      } else {
        show_color = Colors.green;
      }
    }
    return Card(
      
      child:  Container(
        padding: new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text(
                stockIndex.name,
                style: new TextStyle(fontSize: 18.0, color: Colors.black),
                textAlign: TextAlign.center,
              ) ,
              flex: 1,
            ),
            Expanded(
              child:new Text(
                stockIndex.current_points,
                style: new TextStyle(fontSize: 22.0, color: show_color),
                textAlign: TextAlign.center,
              ) ,
              flex: 1,
            ),
            Expanded(
              child:            Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child:Text(
                        stockIndex.current_prices,
                        style: new TextStyle(fontSize: 14.0, color: show_color),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child:Text(
                        change_prefix+gains_rate,
                        style: new TextStyle(fontSize: 14.0, color: show_color),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
              flex: 1,
            )
          ],
        ),
      ),
    )
    ;
  }

  /**
   * 处理指数数据
   */
  void DealStockIndess(String str, StockIndex stockIndex) {
    int start = str.indexOf("\"") + 1;
    int end = str.indexOf("\"", start);
    stockIndex.stock_code= str.substring(str.indexOf("str_") + 4, start - 2);
    String stock_index_str = str.substring(start, end);
    List index_item = stock_index_str.split(",");
    stockIndex.name=index_item[0];
    stockIndex.current_points=index_item[1];
    stockIndex.current_prices=index_item[2];
    stockIndex.gains_rate=index_item[3];
    stockIndex.traded_num=index_item[4];
    stockIndex.traded_amount=index_item[5];
  }
}
