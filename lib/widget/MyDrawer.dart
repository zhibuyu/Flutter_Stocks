import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyDrawer extends StatelessWidget {
  // 菜单文本前面的图标大小
  static const double IMAGE_ICON_WIDTH = 30.0;
  // 菜单后面的箭头的图标大小
  static const double ARROW_ICON_WIDTH = 16.0;
  // 菜单后面的箭头图片
  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  // 菜单的文本
  List menuTitles = [ '关于', '设置'];
  // 菜单文本前面的图标
  List menuIcons = [
    Icons.assistant_photo,
    Icons.settings
  ];

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: const BoxConstraints.expand(width: 304.0),
      child: new Material(
        elevation: 16.0,
        child: new Container(
          decoration: new BoxDecoration(
            color: const Color(0xFFFFFFFF),
          ),
          child: new ListView.builder(
            itemCount: menuTitles.length * 2 + 1,
            itemBuilder: renderRow,
          ),
        ),
      ),
    );
  }

  Widget getIconImage(path) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 6.0, 0.0),
      child: Icon(path),
    );
  }

  Widget renderRow(BuildContext context, int index) {
    if (index == 0) {

      var img = new Image.asset(
        './images/cover_img.jpg',
        width: 304.0,
        height: 304.0,
      );
      return new Container(
        width: 304.0,
        height: 304.0,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child:     new UserAccountsDrawerHeader(   //Material内置控件
          accountName: new Text('zhibuyu'), //用户名
          accountEmail: new Text('shiwudaozhuan@163.com'),  //用户邮箱
          currentAccountPicture: new GestureDetector( //用户头像
            onTap: () {
              Fluttertoast.showToast(
                  msg: "点击头像",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  bgcolor: "#OOOOOO",
                  textcolor: '#ffffff');
            },
            child: new CircleAvatar(    //圆形图标控件
              backgroundImage: new NetworkImage('https://avatars2.githubusercontent.com/u/12659236?s=460&v=4'),//图片调取自网络
            ),
          ),
          decoration: new BoxDecoration(    //用一个BoxDecoration装饰器提供背景图片
            image: new DecorationImage(
              fit: BoxFit.fill,
              // image: new NetworkImage('https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg')
              //可以试试图片调取自本地。调用本地资源，需要到pubspec.yaml中配置文件路径
              image: new ExactAssetImage('images/cover_img.jpg'),
            ),
          ),
        ),
      );
    }
    // 舍去之前的封面图
    index -= 1;
    // 如果是奇数则渲染分割线
    if (index.isOdd) {
      return new Divider();
    }
    // 偶数，就除2取整，然后渲染菜单item
    index = index ~/ 2;
    // 菜单item组件
    var listItemContent = new Padding(
      // 设置item的外边距
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      // Row组件构成item的一行
      child: new Row(
        children: <Widget>[
          // 菜单item的图标
          getIconImage(menuIcons[index]),
          // 菜单item的文本，需要
          new Expanded(
            child: new Text(
              menuTitles[index],
              style: new TextStyle(
                fontSize: 15.0,
              ),
            )
          ),
          rightArrowIcon
        ],
      ),
    );

    return new InkWell(
      child: listItemContent,
      onTap: () {
        switch (index) {
          case 0:
            // 关于
            Fluttertoast.showToast(
                msg: "关于",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                bgcolor: "#OOOOOO",
                textcolor: '#ffffff');
            break;
          case 1:
            // 设置
            Fluttertoast.showToast(
                msg: "设置",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                bgcolor: "#OOOOOO",
                textcolor: '#ffffff');
            break;
        }
      },
    );
  }
}
