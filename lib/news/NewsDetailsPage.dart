import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
/**
 * @Description  新闻详情
 * @Author  zhibuyu
 * @Date 2018/11/5  13:35
 * @Version  1.0
 */
class NewsDetailsPage extends StatefulWidget {

  String title,content;

  NewsDetailsPage(this.title, this.content);

  @override
  State<StatefulWidget> createState() => new NewsDetailsPageState(title,content);
}

class NewsDetailsPageState extends State<NewsDetailsPage> {
  String title,content;

  NewsDetailsPageState(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        title: Container(
          margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: Text("新闻详情",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
        centerTitle: true,
      ),
      body:new SingleChildScrollView(
        child:  new Center(
          child: Column(
            children: <Widget>[
              Container(
                child:
                Text(title,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                alignment: FractionalOffset.center,
              ),
              Html(
                data: content,
                padding: EdgeInsets.all(8.0),
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                customRender: (node, children){
                    if (node is dom.Element) {
                      switch (node.localName) {
                        case "custom_tag":
                          return Column(children: children);
                      }
                    }
                },
              ),

            ],
          )
         ,
        ),
      ),
    );
  }
}
