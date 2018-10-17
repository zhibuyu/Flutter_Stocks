import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class TweetsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TweetsListPageState();
  }
}

class TweetsListPageState extends State<TweetsListPage> {
  List hotTweetsList;
  List normalTweetsList;
  TextStyle authorTextStyle;
  TextStyle subtitleStyle;
  RegExp regExp1 = new RegExp("</.*>");
  RegExp regExp2 = new RegExp("<.*>");
  num curPage = 1;
  bool loading = false;
  ScrollController _controller;
  bool isUserLogin = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.isUserLogin = false;
    });

  }

  TweetsListPageState() {
    authorTextStyle =
        new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
    subtitleStyle =
        new TextStyle(fontSize: 12.0, color: const Color(0xFFB5BDC0));
    _controller = new ScrollController();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        // load next page
        curPage++;
      }
    });
  }



  // 去掉文本中的html代码
  String clearHtmlContent(String str) {
    if (str.startsWith("<emoji")) {
      return "[emoji]";
    }
    var s = str.replaceAll(regExp1, "");
    s = s.replaceAll(regExp2, "");
    s = s.replaceAll("\n", "");
    return s;
  }

  Widget getRowWidget(Map<String, dynamic> listItem) {
    var authorRow = new Row(
      children: <Widget>[
        new Container(
          width: 35.0,
          height: 35.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            image: new DecorationImage(
                image: new NetworkImage(listItem['portrait']),
                fit: BoxFit.cover),
            border: new Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
          child: new Text(
            listItem['author'],
            style: new TextStyle(fontSize: 16.0)
          )
        ),
        new Expanded(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(
                '${listItem['commentCount']}',
                style: subtitleStyle,
              ),
              new Image.asset(
                './images/ic_comment.png',
                width: 16.0,
                height: 16.0,
              )
            ],
          ),
        )
      ],
    );
    var _body = listItem['body'];
    _body = clearHtmlContent(_body);
    var contentRow = new Row(
      children: <Widget>[
        new Expanded(child: new Text(_body))
      ],
    );
    var timeRow = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Text(
          listItem['pubDate'],
          style: subtitleStyle,
        )
      ],
    );
    var columns = <Widget>[
      new Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 2.0),
        child: authorRow,
      ),
      new Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 0.0, 10.0, 0.0),
        child: contentRow,
      ),
    ];
    String imgSmall = listItem['imgSmall'];
    if (imgSmall != null && imgSmall.length > 0) {
      // 动弹中有图片
      List<String> list = imgSmall.split(",");
      List<String> imgUrlList = new List<String>();
      for (String s in list) {
        if (s.startsWith("http")) {
          imgUrlList.add(s);
        } else {
          imgUrlList.add("https://static.oschina.net/uploads/space/" + s);
        }
      }
      List<Widget> imgList = [];
      List<List<Widget>> rows = [];
      num len = imgUrlList.length;
      for (var row = 0; row < getRow(len); row++) {
        List<Widget> rowArr = [];
        for (var col = 0; col < 3; col++) {
          num index = row * 3 + col;
          num screenWidth = MediaQuery.of(context).size.width;
          double cellWidth = (screenWidth - 100) / 3;
          if (index < len) {
            rowArr.add(new Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Image.network(imgUrlList[index],
                  width: cellWidth, height: cellWidth),
            ));
          }
        }
        rows.add(rowArr);
      }
      for (var row in rows) {
        imgList.add(new Row(
          children: row,
        ));
      }
      columns.add(new Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 5.0, 10.0, 0.0),
        child: new Column(
          children: imgList,
        ),
      ));
    }
    columns.add(new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 6.0),
      child: timeRow,
    ));
    return new InkWell(
      child: new Column(
        children: columns,
      ),
      onTap: () {
        // 跳转到动弹详情
//        Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
//          return new TweetDetailPage(
//            tweetData: listItem,
//          );
//        }));
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return new AlertDialog(
              title: new Text('提示'),
              content: new Text('要把\"${listItem['author']}\"关进小黑屋吗？'),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    '取消',
                    style: new TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text(
                    '确定',
                    style: new TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
//                    putIntoBlackHouse(listItem);
                  },
                )
              ],
            );
          });
      },
    );
  }


  showAddBlackHouseResultDialog(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return new AlertDialog(
          title: new Text('提示'),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                '确定',
                style: new TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
  }

  renderHotRow(i) {
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      i = i ~/ 2;
      return getRowWidget(hotTweetsList[i]);
    }
  }

  renderNormalRow(i) {
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      i = i ~/ 2;
      return getRowWidget(normalTweetsList[i]);
    }
  }

  int getRow(int n) {
    int a = n % 3;
    int b = n ~/ 3;
    if (a != 0) {
      return b + 1;
    }
    return b;
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    return null;
  }

  Widget getHotListView() {
    if (hotTweetsList == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      // 热门动弹列表
      return new ListView.builder(
        itemCount: hotTweetsList.length * 2 - 1,
        itemBuilder: (context, i) => renderHotRow(i),
      );
    }
  }

  Widget getNormalListView() {
    if (normalTweetsList == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      // 普通动弹列表
      return new RefreshIndicator(
        child: new ListView.builder(
          itemCount: normalTweetsList.length * 2 - 1,
          itemBuilder: (context, i) => renderNormalRow(i),
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
        ),
        onRefresh: _pullToRefresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserLogin) {
      return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Center(
                child: new Column(
                  children: <Widget>[
                    new Text("由于OSC的openapi限制"),
                    new Text("必须登录后才能获取动弹信息")
                  ],
                ),
              )
            ),
            new InkWell(
              child: new Container(
                padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                child: new Text("去登录"),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black),
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0))
                ),
              ),
              onTap: () async {
//                final result = await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
//                  return LoginPage();
//                }));
//                if (result != null && result == "refresh") {
//                  // 通知动弹页面刷新
//                  Constants.eventBus.fire(new LoginEvent());
//                }
              },
            ),
          ],
        ),
      );
    }
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new TabBar(
          tabs: <Widget>[
            new Tab(text: "动弹列表"),
            new Tab(text: "热门动弹")
          ],
        ),
        body: new TabBarView(
          children: <Widget>[getNormalListView(), getHotListView()],
        )),
    );
  }
}
