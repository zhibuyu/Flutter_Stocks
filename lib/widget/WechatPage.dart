import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/**
 * @Description  微信打赏
 * @Author  zhibuyu
 * @Date 2018/10/30  21:01
 * @Version  1.0
 */
class WechatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WechatPagePageState();
}

class WechatPagePageState extends State<WechatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          brightness: Brightness.light,
          title: Container(
            margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
            child: Text("我的微信",
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          centerTitle: true,
        ),
        body: new Column(children: <Widget>[
//        Image.asset("images/wechart_add.jpg",),
        Image.asset("images/wechat_pay.png",),
        ]));
  }
}
