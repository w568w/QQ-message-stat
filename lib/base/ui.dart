import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui_model.dart';

export 'ui_model.dart';
export 'package:flutter/material.dart';

/// UI容器，即 StatefulWidget的 包装
class BaseUIContainer extends StatefulWidget {
  final BaseUI ui;

  BaseUIContainer(this.ui, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ui;
}

///
/// UI包装，封装常用 UI 参数 及 方法
///
/// 关于 UI class 的 参数传递：
///
/// class TestUI extends BaseUI {
///   final int a;
///   TestUI(this.a); // 使用构造方法接收参数
///   ....
///
///    /// 使用 Navigator.pop 返回参数：
///    Navigator.pop(context,false);
///
/// }
///
/// 传入参数，及获得参数回调，回调数据类型为 dynamic ：
///  final result = await TestUI(1).pushToPage<TestModel>(TestModel());
///
/// 只有在数据仅 在 UI 展示，并且无需更新时，才允许将参数放入UI，
/// 否则，请使用 UIModel 传参。 参见：[BaseUIModel]
///
abstract class BaseUI extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBodyBackgroundColor(context),
      body: buildBody(context),
    );
  }

  /// body 默认背景色
  Color getBodyBackgroundColor(BuildContext context) {
    return const Color.fromARGB(255, 247, 250, 255);
  }

  /// 构建 Body ，由 子类 继承实现
  Widget buildBody(BuildContext context);

  /// 将 View 绑定 至 ViewModel，由子类实现
  /// 因 构成 View 的最小单位可大可小，不好分辨，并且打起来太麻烦，古使用 UI 代替。
  /// UI 代表了页面的最顶级容器。
  /// bindUIModel 在继承实现后，需手动将 BaseUIModel 改为目标 UI 所需的 类型。
  BaseUIModel bindUIModel(BuildContext context, {bool listen = true});

  /// 跳转至 页面
  /// T 为 Model 的 Type
  /// context 为 上级页面的 BuildContext
  /// model 为 ModelType 的实例化对象
  Future pushToPage<T extends BaseUIModel>(
      BuildContext context, Create<T> model) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => createWidget<T>(model)));
  }

  /// 创建 Widget
  /// 这将创建具有 [Provider] 与 [BaseUIContainer] 包装的 [Widget]，可供页面直接使用
  ///
  /// 如果[model]为null，则不包装，直接返回[BaseUIContainer]
  Widget createWidget<T extends BaseUIModel>(Create<T>? model, {Key? key}) {
    if (model != null)
      return ChangeNotifierProvider(
        key: key,
        create: model,
        child: BaseUIContainer(this),
      );
    else
      return BaseUIContainer(this, key: key);
  }
}
