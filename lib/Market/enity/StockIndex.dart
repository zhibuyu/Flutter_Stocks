/**
 * @Description  大盘指数
 * @Author  zhibuyu
 * @Date 2018/10/26  14:35
 * @Version  1.0
 */
class StockIndex extends Object {
  var stock_code2;//指数代码
  var stock_code;//指数代码
  var name; //指数名称
  var current_points; //当前点数
  var current_prices; //当前价格
  var gains_rate;//涨跌率
  var traded_num; //成交量（手)
  var traded_amount;//成交额（万元）；

  @override
  String toString() {
    return 'StockIndex{stock_code2: $stock_code2, stock_code: $stock_code, name: $name, current_points: $current_points, current_prices: $current_prices, gains_rate: $gains_rate, traded_num: $traded_num, traded_amount: $traded_amount}';
  }

}
