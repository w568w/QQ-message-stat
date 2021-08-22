/*
 * Copyright (c) 2021. w568w
 */

import 'package:flutter/services.dart';
import 'package:qq_message_log_stat/base/provider.dart';
import 'package:qq_message_log_stat/base/ui.dart';

import 'main_UIModel.dart';

class MainUI extends BaseUI {
  @override
  MainUIModel bindUIModel(BuildContext context, {bool listen = true}) {
    return MyProvider.of<MainUIModel>(context, listen: listen);
  }

  @override
  Widget buildBody(BuildContext context) {
    final model = bindUIModel(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(model.appTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                model.appTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '使用方法：使用 PC 版 QQ，在你要保存的人/群里选择[消息记录]，点击右下角的[消息管理]。\n在人/群名上右键，选择[导出聊天记录]，选择[.txt，不支持导入]，保存文件。\n然后在这里上传即可',
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                width: 400,
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: '多少秒不说话算冷场？'),
                  controller: model.thresholdDurationController,
                ),
              ),
              ElevatedButton(
                  onPressed: model.isProcessing ? null : model.uploadFile,
                  child: Text('选择 .txt 文件'))
            ],
          ),
        ));
  }
}
