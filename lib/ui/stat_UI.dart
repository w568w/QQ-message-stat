/*
 * Copyright (c) 2021. w568w
 */

import 'package:qq_message_log_stat/base/provider.dart';
import 'package:qq_message_log_stat/base/ui.dart';
import 'package:qq_message_log_stat/model/message_stat.dart';
import 'package:qq_message_log_stat/model/pair.dart';
import 'package:qq_message_log_stat/ui/stat_UIModel.dart';

import 'main_UIModel.dart';

class StatUI extends BaseUI {
  @override
  StatUIModel bindUIModel(BuildContext context, {bool listen = true}) {
    return MyProvider.of<StatUIModel>(context, listen: listen);
  }

  static String longestTalk(QQMessageStat stat, Pair<int, int> strip) {
    return '起始于${stat.messages[stat.talkGroups[strip.first].first].sendTime}, '
        '你们说了 ${strip.second} 句话, '
        '这场对话一直持续到 ${stat.messages[stat.talkGroups[strip.first].last].sendTime} ';
  }

  @override
  Widget buildBody(BuildContext context) {
    final model = bindUIModel(context);
    final stat = model.stat;
    return Scaffold(
        appBar: AppBar(
          title: Text('统计结果'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '龙王',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          '${stat.activity.first.first}, Ta 一共说了 ${stat.activity.first.second} 句话',
                        ),
                        if (stat.activity.length > 1)
                          Text(
                            '其次是${stat.activity[1].first}, Ta 一共说了 ${stat.activity[1].second} 句话',
                          ),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 400,
                                width: 400,
                                child: ListView.builder(
                                    itemCount: stat.activity.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            ListTile(
                                              title: Text(
                                                  stat.activity[index].first),
                                              subtitle: Text(stat
                                                  .activity[index].second
                                                  .toString()),
                                            )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '冷场王',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          '${stat.silence.first.first}, Ta 冷场了 ${stat.silence.first.second} 次',
                        ),
                        if (stat.silence.length > 1)
                          Text(
                            '其次是${stat.silence[1].first}, Ta 冷场了 ${stat.silence[1].second} 次',
                          ),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 400,
                                width: 400,
                                child: ListView.builder(
                                    itemCount: stat.silence.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        ListTile(
                                          title:
                                              Text(stat.silence[index].first),
                                          subtitle: Text(stat
                                              .silence[index].second
                                              .toString()),
                                        )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '瞬间99+!',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          '最长的一次连续聊天${longestTalk(stat, stat.talkGroupStrips.first)}',
                        ),
                        if (stat.talkGroupStrips.length > 1)
                          Text(
                            '第二长的聊天${longestTalk(stat, stat.talkGroupStrips[1])}',
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
