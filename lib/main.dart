/*
 * Copyright (c) 2021. w568w
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qq_message_log_stat/ui/main_UI.dart';
import 'package:qq_message_log_stat/ui/main_UIModel.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'QQ聊天记录统计器',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainUI().createWidget<MainUIModel>((context) => MainUIModel('QQ聊天记录统计器')));
  }
}
