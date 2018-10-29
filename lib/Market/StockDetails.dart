import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mystocks/Market/enity/Stock.dart';

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

class StockDetails extends StatefulWidget {
  Stock stock;

  StockDetails(this.stock);

  @override
  State<StatefulWidget> createState() => new StockDetailsState(stock);
}

class StockDetailsState extends State<StockDetails>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  Stock stock;
  List<_Page> _allPages = [];
  _Page _selectedPage;

  List StockComments = [];

  StockDetailsState(this.stock);

  @override
  void initState() {
    //日K线查询：
    String daily_kimg_url = "http://image.sinajs.cn/newchart/daily/n/" +
        stock.stock_code2.toString() +
        ".gif";
    //分时线的查询：
    String min_kimg_url = "http://image.sinajs.cn/newchart/min/n/" +
        stock.stock_code2.toString() +
        ".gif";
    //周K线查询：
    String weekly_kimg_url = "http://image.sinajs.cn/newchart/weekly/n/" +
        stock.stock_code2.toString() +
        ".gif";
    //月K线查询：
    String monthly_kimg_url = "http://image.sinajs.cn/newchart/monthly/n/" +
        stock.stock_code2.toString() +
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: buildAppBar(), body: getKline());
  }

  buildAppBar() {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.white),
      brightness: Brightness.light,
      flexibleSpace: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))))),
      title: Container(
        margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            Text(stock.name,
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            Text(stock.stock_code,
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

  getKline() {
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
          child: new CachedNetworkImage(
        imageUrl: page.img_url,
        errorWidget: new Icon(Icons.error),
      ));
    });
  }

  getListView() {
    return ListView.builder(
      itemCount: (StockComments == null) ? 0 : StockComments.length,
      itemBuilder: (BuildContext context, int position) {
        return getCommentsItem(position);
      },
      physics: new AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  getCommentsItem(int position) {
    return new Text("评论");
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
}
