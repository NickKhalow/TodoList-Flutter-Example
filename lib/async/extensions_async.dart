import 'package:flutter/widgets.dart';

extension Extensions<T> on AsyncSnapshot<T> {
  Widget widgetFor(
      {required Widget Function(T) onData,
      required Widget Function() onProgress,
      required Widget Function(Object) onError}) {
    if (hasData) return onData(data as T);
    if (hasError) return onError(error as Object);
    return onProgress();
  }
}
