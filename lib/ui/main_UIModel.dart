/*
 * Copyright (c) 2021. w568w
 */

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:qq_message_log_stat/base/ui.dart';
import 'package:qq_message_log_stat/model/message.dart';
import 'package:qq_message_log_stat/model/message_stat.dart';
import 'package:qq_message_log_stat/model/pair.dart';
import 'package:qq_message_log_stat/ui/stat_UI.dart';
import 'package:qq_message_log_stat/ui/stat_UIModel.dart';

class MainUIModel extends BaseUIModel {
  final String appTitle;
  final TextEditingController thresholdDurationController =
      TextEditingController(text: '600');

  MainUIModel(this.appTitle);

  bool isProcessing = false;

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: const ['txt']);
    if (result != null) {
      isProcessing = true;
      notifyListeners();

      String txt = utf8.decode(result.files.first.bytes ??
          await File(result.files.first.path!).readAsBytes());
      List<QQMessage> list = QQMessage.fromLogText(txt);
      QQMessageStat res =
          await compute<Pair<List<QQMessage>, Duration>, QQMessageStat>(
              QQMessageStat.statCompute,
              Pair(
                  list,
                  Duration(
                      seconds: int.parse(thresholdDurationController.text))));

      isProcessing = false;
      notifyListeners();

      StatUI().pushToPage<StatUIModel>(context, (context) => StatUIModel(res));
    } else {
      // User canceled the picker
    }
  }
}
