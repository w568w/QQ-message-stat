/*
 * Copyright (c) 2021. w568w
 */

import 'package:flutter/cupertino.dart';

class QQMessage {
  final String name;
  final DateTime sendTime;
  final String message;
  static final _messageRegex =
      RegExp(r'(\d{4}-\d{2}-\d{2} \d{1,2}:\d{2}:\d{2}) (.+)[\r\n]{1,2}' //时间和用户名
          r'([\S\s]+?)' //消息内容，非贪婪
          r'(?=([\r\n]{2,}\d{4}-\d{2}-\d{2})|($))' //后向断言到下一行或文件末
          );

  QQMessage(this.name, this.sendTime, this.message);

  static _normalizeTimeFormat(String originTimeText) {
    originTimeText = originTimeText.trim();
    final abnormalTimeRegex = RegExp(r' \d{1}:');
    if (abnormalTimeRegex.hasMatch(originTimeText)) {
      originTimeText = originTimeText.replaceFirst(' ', ' 0');
    }
    return originTimeText;
  }

  static List<QQMessage> fromLogText(String text) => _messageRegex
      .allMatches(text)
      .map((e) => QQMessage(e.group(2)!,
          DateTime.parse(_normalizeTimeFormat(e.group(1)!)), e.group(3)!))
      .toList();

  @override
  String toString() => '{$sendTime $name : "$message"}';
}
