/**
 * @Description  计算工具类
 * @Author  zhibuyu
 * @Date 2018/10/26  18:45
 * @Version  1.0
 */

/**
 * 计算涨跌幅率
 * @parm yesterday_close 昨收价
 * @parm current_prices 当前价格
 * @parm today_open 今日开盘价
 */
double ComputeGainsRate(double yesterday_close,double current_prices,double today_open){
  double result;
  if(current_prices==0){
    result=0.0;
  }else{
    if(yesterday_close!=0){
      result=(current_prices-yesterday_close)/yesterday_close;
    }else{
      if(today_open!=0){
        result=(current_prices-today_open)/today_open;
      }else{
        result=0.0;
      }
    }
  }
  return result;
}

/**
 * 计算涨跌幅
 * @parm yesterday_close 昨收价
 * @parm current_prices 当前价格
 * @parm today_open 今日开盘价
 */
String ComputeGainsNum(double yesterday_close,double current_prices,double today_open){
  String gains_num;
  if (current_prices == 0) {
    gains_num = "0.00";
  } else {
    if (yesterday_close != 0) {
      gains_num = (current_prices - yesterday_close).toStringAsFixed(2);
    } else {
      if (today_open != 0) {
        gains_num = (current_prices - today_open).toStringAsFixed(2);
      } else {
        gains_num = "0.00";
      }
    }
  }
  return gains_num;
}