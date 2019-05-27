import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystocks/market/enity/Stock.dart';
import 'package:mystocks/market/enity/StockIndex.dart';
import 'package:mystocks/Util/ComputeUtil.dart';
import 'package:mystocks/Util/Constants.dart';
import 'package:mystocks/Util/DataUtils.dart';
import 'package:mystocks/news/entiy/ListEnity.dart';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:mystocks/util/HexColor.dart';
/**
 * @Description  个股详情
 * @Author  zhibuyu
 * @Date 2018/10/29  13:36
 * @Version  1.0
 */

class _Page {
  String label;
  String img_url;

  _Page(this.label, this.img_url);
}

class StockDetailsPage extends StatefulWidget {
  ListEnity enity;

  StockDetailsPage(this.enity);

  @override
  State<StatefulWidget> createState() => new StockDetailsPageState(enity);
}

class StockDetailsPageState extends State<StockDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  ListEnity enity;
  List<_Page> _allPages = [];
  _Page _selectedPage;

  List StockComments = [];
  double traded_num,
      traded_amount,
      gains,
      yesterday_close,
      current_prices,
      today_open;
  String type, stock_code2, stock_code, stock_name;

  StockDetailsPageState(this.enity);

  @override
  void initState() {
    type = enity.type;
    initData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: new RefreshIndicator(
            child: mainWidget(), onRefresh: pullToRefresh));
  }

  void initData(){
    if ("stock" == type) {
      Stock stock = enity.data;
      stock_name = stock.name;
      stock_code = stock.stock_code;
      stock_code2 = stock.stock_code2;
      traded_num = double.parse(stock.traded_num);
      traded_amount = double.parse(stock.traded_amount);
      gains = stock.gains;

      yesterday_close = double.parse(stock.yesterday_close);
      current_prices = double.parse(stock.current_prices);
      today_open = double.parse(stock.today_open);
    } else {
      StockIndex stockIndex = enity.data;
      stock_name = stockIndex.name;
      stock_code = stockIndex.stock_code;
      stock_code2 = stockIndex.stock_code2;
    }
    //日K线查询：
    String daily_kimg_url =
        "http://image.sinajs.cn/newchart/daily/n/" + stock_code2 + ".gif";
    //分时线的查询：
    String min_kimg_url = "http://image.sinajs.cn/newchart/min/n/" +
        stock_code2.toString() +
        ".gif";
    //周K线查询：
    String weekly_kimg_url = "http://image.sinajs.cn/newchart/weekly/n/" +
        stock_code2.toString() +
        ".gif";
    //月K线查询：
    String monthly_kimg_url = "http://image.sinajs.cn/newchart/monthly/n/" +
        stock_code2.toString() +
        ".gif";
    _allPages = <_Page>[
      _Page("分时", min_kimg_url),
      _Page("日K", daily_kimg_url),
      _Page("周K", weekly_kimg_url),
      _Page("月K", monthly_kimg_url),
    ];
    _controller = TabController(vsync: this, length: _allPages.length);
    _controller.addListener(_handleTabSelection);
    _selectedPage = _allPages[0];
  }
  mainWidget() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          flexibleSpace: buildAppBar(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return new Column(
                children: ShowMainWidget(),
              );
            },
            childCount: 1,
          ),
        )
      ],
    );
  }

  ShowMainWidget() {
    if ("stock" == type) {
      return <Widget>[TopMarket(), getKline()];
    } else {
      return <Widget>[getKline()];
    }
  }

  buildAppBar() {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      brightness: Brightness.light,
      title: Container(
        margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            Text(stock_name,
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            Text(stock_code,
                style: new TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w200,
                    color: Colors.white)),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  /**
   * K 线图
   */
  Widget getKline() {
    print('加载K线');
    return new Container(
      height: 300.0,
      child: Scaffold(
        appBar: TabBar(
          controller: _controller,
          tabs: _allPages.map((_Page page) => Tab(text: page.label)).toList(),
        ),
        body: TabBarView(
            controller: _controller,
            children: _allPages.map(buildTabView).toList()),
      ),
    );
  }

  Widget buildTabView(_Page page) {
    return Builder(builder: (BuildContext context) {
      return Container(
          child: CachedNetworkImage(
            imageUrl: page.img_url,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ));
    });
  }

  /**
   * 顶部行情部分
   */
  Widget TopMarket() {
    return new Container(
      margin: new EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
      height: 50.0,
      child: Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              child: ShowPrices(),
            ),
            flex: 1,
          ),
          new Expanded(
            child: new Container(
              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "今    开",
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.black38),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              today_open.toStringAsFixed(2),
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            alignment: FractionalOffset.centerRight,
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "成交量",
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.black38),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              (traded_num / 1000000).toStringAsFixed(2) + "万手",
                              maxLines: 1,
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            alignment: FractionalOffset.centerRight,
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
            flex: 1,
          ),
          new Expanded(
            child: new Container(
              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new Column(children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "昨    收",
                        style: new TextStyle(
                            fontSize: 12.0, color: Colors.black38),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            yesterday_close.toStringAsFixed(2),
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.black),
                          ),
                          alignment: FractionalOffset.centerRight,
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "成交额",
                        style: new TextStyle(
                            fontSize: 12.0, color: Colors.black38),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            (traded_amount ~/ 10000).toString() + "万",
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.black),
                            maxLines: 1,
                          ),
                          alignment: FractionalOffset.centerRight,
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  flex: 1,
                )
              ]),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  /**
   * 主要价格信息
   */
  ShowPrices() {
    Color show_color;
    String gains_num =
        ComputeGainsNum(yesterday_close, current_prices, today_open);
    String gains_str = (gains * 100).toStringAsFixed(2) + "%";
    if (gains > 0) {
      show_color = Colors.red;
      gains_str = "+" + gains_str;
      gains_num = "+" + gains_num;
    } else if (gains < 0) {
      show_color = Colors.green;
    } else {
      show_color = Colors.black38;
    }
    return new Container(
      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              current_prices.toStringAsFixed(2),
              style: new TextStyle(fontSize: 24.0, color: show_color),
            ),
            margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
            alignment: FractionalOffset.topLeft,
          ),
          new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    gains_num,
                    style: new TextStyle(fontSize: 12.0, color: show_color),
                    textAlign: TextAlign.left,
                  ),
                  alignment: FractionalOffset.bottomLeft,
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    gains_str,
                    style: new TextStyle(fontSize: 12.0, color: show_color),
                    textAlign: TextAlign.left,
                  ),
                  alignment: FractionalOffset.bottomLeft,
                ),
                flex: 1,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedPage = _allPages[_controller.index];
    });
  }

  Future<Null> pullToRefresh() async {
    getDatas(REFRESH_REQIEST);
    return null;
  }

  void getDatas(int request_type) {
    if ("stock" == type) {
      String url = "http://hq.sinajs.cn/list=" + stock_code2;
      fetch(url).then((data) {
        setState(() {
          List<String> stockstrs = data.split(";");
          setState(() {
            String str = stockstrs[0];
            Stock stock = new Stock();
            stock= DealStocks(str, stock);
            traded_num = double.parse(stock.traded_num);
            traded_amount = double.parse(stock.traded_amount);
            gains = ComputeGainsRate(yesterday_close, current_prices, today_open);

            yesterday_close = double.parse(stock.yesterday_close);
            current_prices = double.parse(stock.current_prices);
            today_open = double.parse(stock.today_open);
          });
          if (request_type == REFRESH_REQIEST) {
            Fluttertoast.showToast(
                msg: "刷新成功",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: HexColor("#OOOOOO"),
                textColor: HexColor('#ffffff'));
          }
        });
      }).catchError((e) {
        Fluttertoast.showToast(
            msg: "网络异常，请检查",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: HexColor("#OOOOOO"),
            textColor: HexColor('#ffffff'));
      });
    }
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }
}
