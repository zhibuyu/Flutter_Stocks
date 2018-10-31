/**
 * @Description  数据处理
 * @Author  zhibuyu
 * @Date 2018/10/31  10:32
 * @Version  1.0
 */

import 'package:mystocks/Market/enity/Stock.dart';

/**
 * 处理股票数据
 */
Stock DealStocks(String str, Stock stock) {
  int start = str.indexOf("\"") + 1;
  int end = str.indexOf("\"", start);
  stock.stock_code2= str.substring(str.indexOf("str_") + 4, start - 2);
  stock.stock_code = str.substring(str.indexOf("str_") + 6, start - 2);
  String stock_str = str.substring(start, end);
  List stock_item = stock_str.split(",");
  stock.name = stock_item[0];
  stock.today_open = stock_item[1];
  stock.yesterday_close = stock_item[2];
  stock.current_prices = stock_item[3];
  stock.today_highest_price = stock_item[4];
  stock.today_lowest_price = stock_item[5];
  stock.buy1_j = stock_item[6];
  stock.sell1_j = stock_item[7];
  stock.traded_num = stock_item[8];
  stock.traded_amount = stock_item[9];
  stock.buy1_apply_num = stock_item[10];
  stock.buy1 = stock_item[11];
  stock.buy2_apply_num = stock_item[12];
  stock.buy2 = stock_item[13];
  stock.buy3_apply_num = stock_item[14];
  stock.buy3 = stock_item[15];
  stock.buy4_apply_num = stock_item[16];
  stock.buy4 = stock_item[17];
  stock.buy5_apply_num = stock_item[18];
  stock.buy5 = stock_item[19];
  stock.sell1_apply_num = stock_item[20];
  stock.sell1 = stock_item[21];
  stock.sell2_apply_num = stock_item[22];
  stock.sell2 = stock_item[23];
  stock.sell3_apply_num = stock_item[24];
  stock.sell3 = stock_item[25];
  stock.sell4_apply_num = stock_item[26];
  stock.sell4 = stock_item[27];
  stock.sell5_apply_num = stock_item[28];
  stock.sell5 = stock_item[29];
  stock.date = stock_item[30];
  stock.time = stock_item[31];
  return stock;
}