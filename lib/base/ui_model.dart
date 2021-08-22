import 'package:flutter/widgets.dart';

/// 基础 UIModel 类型
/// 封装了常用 Model 方法
/// 不需要展示在 UI 中的数据应当使用 UIModel 传参，而非UI
class BaseUIModel extends ChangeNotifier {
  bool disposed = false;

  late BuildContext context;

  @override
  void notifyListeners() {
    if (!hasListeners) {
      return;
    }
    if (disposed) {
      return;
    }
    super.notifyListeners();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
