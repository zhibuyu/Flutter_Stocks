import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart';
import 'package:mystocks/Login/LoginPage.dart';
import 'package:mystocks/news/NewsWebPage.dart';
import 'package:mystocks/widget/WechatPage.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:share/share.dart';

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

  var titles = ["", "我的博客", "我的Github", "我的微信", "意见反馈", "分享"];
  List icons = [
    Icons.assignment,
    Icons.all_inclusive,
    Icons.supervisor_account,
    Icons.email,
    Icons.share
  ];
  var userAvatar;
  var userName;
  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  @override
  void initState() {
    super.initState();
    fluwx.register(appId: "wx2785c3e35d586781");
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
              ),
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
                  child: Icon(icons[i - 1]),
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                ),
                new Expanded(
                    child: new Text(
                  titles[i],
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
        _handleListItemClick(i);
      },
    );
  }

  _handleListItemClick(int index) {
    switch (index) {
      case 1:
        String h5_url = "https://blog.csdn.net/u010123643";
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new NewsWebPage(h5_url, '我的博客')));
        break;
      case 2:
        String h5_url = "https://github.com/zhibuyu";
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new NewsWebPage(h5_url, '我的开源')));
        break;
      case 3:
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new WechatPage()));
        break;
      case 4:
        String h5_url = "https://github.com/zhibuyu/Flutter_Stocks/issues";
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new NewsWebPage(h5_url, '意见反馈')));
        break;
      case 5:
        showDemoDialog<String>(
          context: context,
          child: const CupertinoDessertDialog(),
        );

        break;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('You selected: $value'),
          ),
        );
      }
    });
  }
}

class CupertinoDessertDialog extends StatelessWidget {
  const CupertinoDessertDialog({Key key, this.title, this.content})
      : super(key: key);

  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('全平台分享'),
          onPressed: () {
            final RenderBox box = context.findRenderObject();
            Share.share("https://github.com/zhibuyu/Flutter_Stocks/blob/master/apk/mystocks.apk",
                sharePositionOrigin:
                box.localToGlobal(Offset.zero) &
                box.size);
            Navigator.pop(context, 'Cancel');
          },
        ),
        CupertinoDialogAction(
          child: const Text('微信好友'),
          onPressed: () {
            fluwx.share(WeChatShareImageModel(
                image: "assets://images/down_qrcode.png",
                thumbnail: "",
                transaction: "",
                scene: WeChatScene.SESSION,
                description: "image"));
            Navigator.pop(context, 'Cancel');
          },
        ),
        CupertinoDialogAction(
          child: const Text('微信朋友圈'),
          onPressed: () {
            fluwx.share(WeChatShareImageModel(
                image: "assets://images/down_qrcode.png",
                thumbnail: "",
                transaction: "",
                scene: WeChatScene.TIMELINE,
                description: "image"));
            Navigator.pop(context, 'Cancel');
          },
        ),
        CupertinoDialogAction(
          child: const Text("微信收藏"),
          onPressed: () {
            fluwx.share(WeChatShareImageModel(
                image: "assets://images/down_qrcode.png",
                thumbnail: "",
                transaction: "",
                scene: WeChatScene.FAVORITE,
                description: "image"));
            Navigator.pop(context, 'Cancel');
          },
        ),
        CupertinoDialogAction(
          child: const Text('取消'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ],
    );
  }
}
