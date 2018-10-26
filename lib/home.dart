import 'package:flutter/material.dart';
import 'package:mystocks/Market/MarketPage.dart';
import 'package:mystocks/StockComments/StockCommentsPage.dart';
import 'package:mystocks/news/FinanceNews.dart';
import 'package:mystocks/pages/MyInfoPage.dart';
import 'package:mystocks/pages/TestPage.dart';
import 'package:mystocks/widget/CustomIcon.dart';
import 'package:mystocks/widget/CustomInactiveIcon.dart';
import 'package:mystocks/widget/NavigationIconView.dart';

/**
 * 主页
 */
class home extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  homeState createState() => homeState();
}

class homeState extends State<home> with TickerProviderStateMixin {
  int currentIndex = 0;
  BottomNavigationBarType type = BottomNavigationBarType.shifting;
  List<NavigationIconView> navigationViews;
  var body;
  List<Widget> Pages = [];
  FinanceNewsPage financeNewsPage;
  StockCommentsPage stockCommentsPage;
  MarketPage marketPage ;
  TestPage testPage ;
  MyInfoPage myInfoPage = new MyInfoPage();

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
    for (NavigationIconView view in navigationViews) view.controller.dispose();
    super.dispose();
  }

  void rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  void initData() {
    slelectTabIndex(0);
    body = new IndexedStack(
      children: Pages,
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
        slelectTabIndex(index);
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
          '子不语股票',
          style: new TextStyle(color: Colors.white),
        ),
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
    );
  }

  /**
   * 选中后才去new
   */
  void slelectTabIndex(int index) {
    switch(index){
      case 1:
        if(stockCommentsPage==null){
          stockCommentsPage = new StockCommentsPage();
        }
        if(!Pages.contains(stockCommentsPage)){
          Pages.add(stockCommentsPage);
        }
        break;
      case 2:
        if(marketPage==null){
          marketPage = new MarketPage();
        }
        if(!Pages.contains(marketPage)){
          Pages.add(marketPage);
        }
        break;
      case 3:
        if(testPage==null){
          testPage= new TestPage();
        }
        if(!Pages.contains(testPage)){
          Pages.add(testPage);
        }
        break;
      case 4:
        if(myInfoPage==null){
          myInfoPage = new MyInfoPage();
        }
        if(!Pages.contains(myInfoPage)){
          Pages.add(myInfoPage);
        }
        break;
      case 0:
      default:
        if(financeNewsPage==null){
          financeNewsPage = new FinanceNewsPage();
        }
        if(!Pages.contains(financeNewsPage)){
          Pages.add(financeNewsPage);
        }
        break;
    }
  }
}
