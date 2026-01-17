import 'package:flutter/foundation.dart';
import 'log_config.dart';
import 'log_event.dart';
import 'log_level.dart';
import 'tag_logger.dart';

class Log {
  static LogConfig _config = kReleaseMode ? LogConfig.releaseSafe() : LogConfig.debug();

  static void init(LogConfig config) {
    _config = config;
    i('Logger initialized', tag: 'LOG', data: {
      'minLevel': _config.minLevel.name,
      'releaseMode': kReleaseMode,
    });
  }

  static TagLogger tag(String tag) => TagLogger(tag);

  static void t(String msg, {String? tag, Map<String, Object?>? data}) =>
      _emit(LogLevel.trace, msg, tag: tag, data: data);
  static void d(String msg, {String? tag, Map<String, Object?>? data}) =>
      _emit(LogLevel.debug, msg, tag: tag, data: data);
  static void i(String msg, {String? tag, Map<String, Object?>? data}) =>
      _emit(LogLevel.info, msg, tag: tag, data: data);
  static void w(
      String msg, {
        String? tag,
        Object? error,
        StackTrace? st,
        Map<String, Object?>? data,
      }) =>
      _emit(LogLevel.warn, msg, tag: tag, error: error, st: st, data: data);

  static void e(
      String msg, {
        String? tag,
        Object? error,
        StackTrace? st,
        Map<String, Object?>? data,
      }) =>
      _emit(LogLevel.error, msg, tag: tag, error: error, st: st, data: data);

  static void f(
      String msg, {
        String? tag,
        Object? error,
        StackTrace? st,
        Map<String, Object?>? data,
      }) =>
      _emit(LogLevel.fatal, msg, tag: tag, error: error, st: st, data: data);

  static void _emit(
      LogLevel level,
      String msg, {
        String? tag,
        Object? error,
        StackTrace? st,
        Map<String, Object?>? data,
      }) {
    if (_config.minLevel.priority > level.priority) return;

    var safeMsg = _config.sanitizer(msg);
    safeMsg = _limit(safeMsg, _config.maxMessageLength);

    final event = LogEvent(
      level: level,
      message: safeMsg,
      timestamp: DateTime.now(),
      tag: tag,
      error: error,
      stackTrace: st,
      data: data,
    );

    final formatted = _format(event, level);
    for (final sink in _config.sinks) {
      sink.write(event, formatted);
    }
  }

  static String _format(LogEvent e, LogLevel level) {
    final b = StringBuffer();

    if (_config.printTime) {
      final t = e.timestamp.toIso8601String();
      b.write('[$t] ');
    }

    if (_config.printLevel) {
      b.write('[${level.name.toUpperCase()}] ');
    }

    if (_config.printTag && (e.tag?.isNotEmpty ?? false)) {
      b.write('[${e.tag}] ');
    }

    b.write(e.message);

    if (e.data != null && e.data!.isNotEmpty) {
      b.write(' | data=');
      b.write(e.data);
    }

    if (e.error != null) {
      b.write('\nerror: ${e.error}');
    }

    if (e.stackTrace != null) {
      b.write('\nstack:\n${e.stackTrace}');
    }

    return b.toString();
  }

  static String _limit(String s, int max) {
    if (s.length <= max) return s;
    return '${s.substring(0, max)}...[TRUNCATED ${s.length - max} chars]';
  }
}
