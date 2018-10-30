import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystocks/Login/LoginPage.dart';

/**
 * @Description  文我的界面
 * @Author  zhibuyu
 * @Date 2018/10/25  10:26
 * @Version  1.0
 */

class MyInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyInfoPageState();
}

class MyInfoPageState extends State<MyInfoPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var titles = ["","我的博客", "我的Github", "我的微信","意见反馈"];
  List icons = [Icons.assignment,Icons.all_inclusive,Icons.supervisor_account,Icons.email];
  var userAvatar;
  var userName;
  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  MyInfoPageState() {

  }

  @override
  void initState() {
    super.initState();
  }

  Widget getIconImage(path) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: new Image.asset(path,
          width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listView = new ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, i) => renderRow(i),
    );
    return listView;
  }

  renderRow(i) {
    if (i == 0) {
      var avatarContainer = new Container(
        color: new Color.fromARGB(255, 0, 215, 198),
        height: 200.0,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? new Image.asset(
                      "images/ic_avatar_default.png",
                      width: 60.0,
                    )
                  : new Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: new DecorationImage(
                            image: new NetworkImage(userAvatar),
                            fit: BoxFit.cover),
                        border: new Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
             Container(
               margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
               child: Text(
                 userName == null ? "点击头像登录" : userName,
                 style: new TextStyle(color: Colors.white, fontSize: 16.0),
               ),
             ) ,
            ],
          ),
        ),
      );
      return new GestureDetector(
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new LoginPage()));
        },
        child: avatarContainer,
      );
    }

    return new InkWell(
      child: Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            child: new Row(
              children: <Widget>[
                Container(
                  child: Icon(icons[i-1]),
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                ),
                new Expanded(
                    child: new Text(titles[i],
                      style: new TextStyle(fontSize: 16.0),
                    )),
                rightArrowIcon
              ],
            ),
          ),
          Divider(
            height: 1.0,
          )
        ],
      ),
      onTap: () {
        _handleListItemClick(i); },
    );
  }

  _handleListItemClick(int index) {
    Fluttertoast.showToast(
        msg: index.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        bgcolor: "#OOOOOO",
        textcolor: '#ffffff');
  }
}
