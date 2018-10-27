/**
 * @Description  行情股票实体类
 * @Author  zhibuyu
 * @Date 2018/10/26  14:35
 * @Version  1.0
 */
class Stock extends Object {
  var stock_code;//股票代码
  var name; //股票名字
  var today_open; //今日开盘价
  var yesterday_close; //昨日收盘价；
  var current_prices; //当前价格
  var today_highest_price; //今日最高价
  var today_lowest_price; //今日最低价
  var buy1_j; //竞买价，即“买一”报价
  var sell1_j; //竞卖价，即“卖一”报价
  var traded_num; //成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
  var traded_amount; //成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
  var buy1_apply_num; //“买一”申请4695股，即47手；
  var buy1; //“买一”报价；
  var buy2_apply_num; //“买二 申请股数”
  var buy2; //“买二”
  var buy3_apply_num; //“买三 申请股数”
  var buy3; //“买三”
  var buy4_apply_num; //“买四 申请股数”
  var buy4; //“买四”
  var buy5_apply_num; //“买五 申请股数”
  var buy5; //“买五”
  var sell1_apply_num; //“卖一”申报3100股，即31手；
  var sell1; //“卖一”报价
  var sell2_apply_num; //“卖二”申请股数；
  var sell2; //“卖二”报价
  var sell3_apply_num; //“卖三”申请股数；
  var sell3; //“卖三”报价
  var sell4_apply_num; //“卖四”申请股数；
  var sell4; //“卖四”报价
  var sell5_apply_num; //“卖五”申请股数；
  var sell5; //“卖五”报价
  var date; //日期；
  var time; //时间；

  @override
  String toString() {
    return 'Stock{stock_code: $stock_code, name: $name, today_open: $today_open, yesterday_close: $yesterday_close, current_prices: $current_prices, today_highest_price: $today_highest_price, today_lowest_price: $today_lowest_price, buy1_j: $buy1_j, sell1_j: $sell1_j, traded_num: $traded_num, traded_amount: $traded_amount, buy1_apply_num: $buy1_apply_num, buy1: $buy1, buy2_apply_num: $buy2_apply_num, buy2: $buy2, buy3_apply_num: $buy3_apply_num, buy3: $buy3, buy4_apply_num: $buy4_apply_num, buy4: $buy4, buy5_apply_num: $buy5_apply_num, buy5: $buy5, sell1_apply_num: $sell1_apply_num, sell1: $sell1, sell2_apply_num: $sell2_apply_num, sell2: $sell2, sell3_apply_num: $sell3_apply_num, sell3: $sell3, sell4_apply_num: $sell4_apply_num, sell4: $sell4, sell5_apply_num: $sell5_apply_num, sell5: $sell5, date: $date, time: $time}';
  }

}
