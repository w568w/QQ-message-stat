import 'ui.dart';
import 'ui_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 带 Context 绑定的 Provider，将 BuildContext 存入 UIModel
class MyProvider<T> {
  /// 该方法原则上应当仅应在 [BaseUI] 实现的 [buildBody] 中调用，
  /// 否则将重复创建监听，并多次重复存入 context
  /// 虽然并不会带来什么大的影响，但还是建议在 Build 时仅绑定一次 Provider。
  /// 当 [UIModel] 被 [buildBody] 作用域之外的方法或对象使用时，请直接传递 [UIModel]。
  static T of<T>(BuildContext context, {bool listen = true}) {
    T provider = Provider.of<T>(context, listen: listen);
    if (provider is BaseUIModel) {
      BaseUIModel viewModel = provider;
      viewModel.context = context;
    }
    return provider;
  }
}
