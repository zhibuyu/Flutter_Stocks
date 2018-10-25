// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mystocks/Market/MarketPage.dart';
import 'package:mystocks/StockComments/StockCommentsPage.dart';
import 'package:mystocks/news/FinanceNews.dart';
import 'package:mystocks/pages/MyInfoPage.dart';
import 'package:mystocks/pages/TestPage.dart';

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  }) : icon = icon,
       color = color,
       title = title,
       item = BottomNavigationBarItem(
         icon: icon,
         activeIcon: activeIcon,
         title: Text(title),
         backgroundColor: color,
       ),
       controller = AnimationController(
         duration: kThemeAnimationDuration,
         vsync: vsync,
       ) {
    animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final Widget icon;
  final Color color;
  final String title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: Semantics(
            label: 'Placeholder for $title tab',
            child: icon,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomInactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      decoration: BoxDecoration(
        border: Border.all(color: iconTheme.color, width: 2.0),
      )
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  BottomNavigationDemoState createState() => BottomNavigationDemoState();
}

class BottomNavigationDemoState extends State<BottomNavigationDemo>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  BottomNavigationBarType type = BottomNavigationBarType.shifting;
  List<NavigationIconView> navigationViews;
  var body;

  @override
  void initState() {
    super.initState();
    navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        title: '新闻',
        color: new Color.fromARGB(255, 0, 215, 198),
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: CustomIcon(),
        icon: CustomInactiveIcon(),
        title: '股票评论',
        color: Colors.deepOrange,
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: const Icon(Icons.cloud),
        icon: const Icon(Icons.cloud_queue),
        title: '行情',
        color: Colors.teal,
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: const Icon(Icons.favorite),
        icon: const Icon(Icons.favorite_border),
        title: '暂空',
        color: Colors.indigo,
        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.event_available),
        title: '我的',
        color: Colors.pink,
        vsync: this,
      )
    ];


    for (NavigationIconView view in navigationViews)
      view.controller.addListener(rebuild);

    navigationViews[currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }


  void initData() {
    body=new IndexedStack(
      children: <Widget>[
        new FinanceNewsPage(),
        new StockCommentsPage(),
        new MarketPage(),
        new TestPage(),
        new MyInfoPage()
      ],
      index: currentIndex,
    );
  }
  @override
  Widget build(BuildContext context) {
    initData();
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: currentIndex,
      type: type,
      onTap: (int index) {
        setState(() {
          navigationViews[currentIndex].controller.reverse();
          currentIndex = index;
          navigationViews[currentIndex].controller.forward();
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: new Text('子不语股票',style: new TextStyle(color: Colors.white),),
        actions: <Widget>[
          PopupMenuButton<BottomNavigationBarType>(
            onSelected: (BottomNavigationBarType value) {
              setState(() {
                type = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<BottomNavigationBarType>>[
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.fixed,
                child: Text('Fixed'),
              ),
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.shifting,
                child: Text('Shifting'),
              )
            ],
          )
        ],
      ),
      body:body,
      bottomNavigationBar: botNavBar,
    );
  }

}
