/*
 * Copyright (c) 2021. w568w
 */

import 'message.dart';
import 'pair.dart';

class QQMessageStat {
  final List<QQMessage> messages;

  /// 龙王。已按发言次数从高到低排序
  final List<Pair<String, int>> activity;

  /// 冷场王。已按冷场次数从高到低排序
  final List<Pair<String, int>> silence;

  /// 聊天组。一组聊天是指相互之间间隔不超过[groupThreshold]时长的对话。
  final List<List<int>> talkGroups;

  /// 聊天组长度，已按长度从高到低排序
  /// 两个 int 分别指在[talkGroups]中的坐标、该 talkGroup 的长度
  final List<Pair<int, int>> talkGroupStrips;

  QQMessageStat(this.messages, this.activity, this.silence, this.talkGroups,
      this.talkGroupStrips);

  static QQMessageStat statCompute(Pair<List<QQMessage>, Duration> parameter) {
    return stat(parameter.first, groupThreshold: parameter.second);
  }

  static QQMessageStat stat(List<QQMessage> messages,
      {Duration groupThreshold = const Duration(seconds: 15)}) {
    Map<String, int> activity = {};
    Map<String, int> silence = {};
    List<List<int>> talkGroups = [];
    List<int> currentGroup = [];
    Map<int, int> talkGroupStrips = {};
    for (int i = 0; i < messages.length; ++i) {
      QQMessage m = messages[i];

      if (!activity.containsKey(m.name)) {
        activity[m.name] = 0;
      }
      activity[m.name] = activity[m.name]! + 1;

      if (i > 0 &&
          messages[i - 1].sendTime.add(groupThreshold).isBefore(m.sendTime)) {
        talkGroups.add(List.from(currentGroup));
        currentGroup.clear();
      }
      currentGroup.add(i);
    }
    if (currentGroup.isNotEmpty) talkGroups.add(List.from(currentGroup));

    for (int i = 0; i < talkGroups.length; ++i) {
      List<int> group = talkGroups[i];
      talkGroupStrips[i] = group.length;
    }

    talkGroups.forEach((element) {
      String lastName = messages[element.last].name;
      if (!silence.containsKey(lastName)) {
        silence[lastName] = 0;
      }
      silence[lastName] = silence[lastName]! + 1;
    });
    return QQMessageStat(
        messages,
        sortMapByValue(activity).toList(),
        sortMapByValue(silence).toList(),
        talkGroups,
        sortMapByValue(talkGroupStrips).toList());
  }

  static Iterable<Pair<T, int>> sortMapByValue<T>(Map<T, int> map) {
    var entries = map.entries.toList();
    entries.sort((a, b) => b.value - a.value);
    return entries.map((e) => Pair(e.key, e.value));
  }
}
