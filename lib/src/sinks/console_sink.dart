import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import '../log_event.dart';
import '../log_level.dart';
import 'log_sink.dart';

class ConsoleSink implements LogSink {
  ConsoleSink._({required this.pretty});

  final bool pretty;

  factory ConsoleSink.pretty() => ConsoleSink._(pretty: true);
  factory ConsoleSink.compact() => ConsoleSink._(pretty: false);

  @override
  void write(LogEvent event, String formatted) {
    // In Flutter, debugPrint avoids truncation better than print.
    if (kIsWeb) {
      // Web console: developer.log is helpful for filtering
      dev.log(formatted, name: event.tag ?? 'APP', level: _toDevLevel(event.level as LogLevel));
    } else {
      debugPrint(formatted);
    }
  }

  int _toDevLevel(LogLevel level) {
    switch (level) {
      case LogLevel.trace:
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warn:
        return 900;
      case LogLevel.error:
      case LogLevel.fatal:
        return 1000;
      case LogLevel.none:
        return 2000;
    }
  }
}
