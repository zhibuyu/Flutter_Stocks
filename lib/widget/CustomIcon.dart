/**
 * @Description  TODO
 * @Author  zhibuyu
 * @Date 2018/10/26  14:10
 * @Version  1.0
 */
import 'package:flutter/material.dart';
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
