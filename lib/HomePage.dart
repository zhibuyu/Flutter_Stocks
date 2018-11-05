import 'package:flutter/material.dart';
import 'package:mystocks/market/MarketPage.dart';
import 'package:mystocks/market/StockIndexPage.dart';
import 'package:mystocks/news/FinanceNewsPage.dart';
import 'package:mystocks/my/MyInfoPage.dart';
import 'package:mystocks/widget/CustomIcon.dart';
import 'package:mystocks/widget/CustomInactiveIcon.dart';
import 'package:mystocks/my/MyDrawer.dart';
import 'package:mystocks/widget/NavigationIconView.dart';

/**
 * 主页
 */
class HomePage extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 0;
  BottomNavigationBarType type = BottomNavigationBarType.shifting;
  List<NavigationIconView> navigationViews;
  var body;
  List<Widget> Pages = [];

  @override
  void initState() {
    super.initState();
    navigationViews = <NavigationIconView>[
      NavigationIconView(
        activeIcon: const Icon(Icons.account_balance),
        icon: const Icon(Icons.access_alarm),
        title: '新闻',
        color: new Color.fromARGB(255, 0, 215, 198),
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: CustomIcon(),
        icon: CustomInactiveIcon(),
        title: '指数',
        color: new Color.fromARGB(255, 0, 215, 198),
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: const Icon(Icons.cloud),
        icon: const Icon(Icons.cloud_queue),
        title: '沪深',
        color: new Color.fromARGB(255, 0, 215, 198),
        vsync: this,
      ),
      NavigationIconView(
        activeIcon: const Icon(Icons.accessibility),
        icon: const Icon(Icons.account_box),
        title: '我的',
        color: new Color.fromARGB(255, 0, 215, 198),
        vsync: this,
      )
    ];

    for (NavigationIconView view in navigationViews)
      view.controller.addListener(rebuild);

    navigationViews[currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in navigationViews) view.controller.dispose();
    super.dispose();
  }

  void rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  void initData() {
    body = new IndexedStack(
      children: [
        new FinanceNewsPage(),
        new StockIndexPage(),
        new MarketPage(),
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
          title: new Text(
            navigationViews[currentIndex].title,
            style: new TextStyle(color: Colors.white),
          ),
          iconTheme: new IconThemeData(color: Colors.white),
          actions: <Widget>[
            PopupMenuButton<BottomNavigationBarType>(
              onSelected: (BottomNavigationBarType value) {
                setState(() {
                  type = value;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<BottomNavigationBarType>>[
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
        body: body,
        bottomNavigationBar: botNavBar,
        drawer: new MyDrawer());
  }
}
