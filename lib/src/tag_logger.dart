import 'log.dart';

class TagLogger {
  TagLogger(this.tag);

  final String tag;

  void t(String msg, {Map<String, Object?>? data}) => Log.t(msg, tag: tag, data: data);
  void d(String msg, {Map<String, Object?>? data}) => Log.d(msg, tag: tag, data: data);
  void i(String msg, {Map<String, Object?>? data}) => Log.i(msg, tag: tag, data: data);
  void w(String msg, {Object? error, StackTrace? st, Map<String, Object?>? data}) =>
      Log.w(msg, tag: tag, error: error, st: st, data: data);
  void e(String msg, {Object? error, StackTrace? st, Map<String, Object?>? data}) =>
      Log.e(msg, tag: tag, error: error, st: st, data: data);
  void f(String msg, {Object? error, StackTrace? st, Map<String, Object?>? data}) =>
      Log.f(msg, tag: tag, error: error, st: st, data: data);
}
